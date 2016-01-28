module FaceHelper
  include ImageUrlHelper

  def recognize_note_photos(note_id)
    Thread.new { recognize_process(note_id) }
  end
  
  private
  
  def recognize_process(note_id)
    
    recognize_note = Note.find(note_id)
    belongs_group = recognize_note.group
    trained_users = belongs_group.get_trained_users
    if !trained_users.any?
      return
    end

    # 認証処理の開始
    recognize_photo_mdls = recognize_note.photos.where(is_movie: false)

    # 認証対象の画像のURLを取得
    recognize_image_urls = []
    recognize_photo_mdls.each do | recognize_photo_mdl |
      recognize_image_urls.push(get_image_url(recognize_photo_mdl.image_data))
    end

    # 認証サービスのユーザーIDを取得
    trained_user_ids = []
    trained_users.each do | trained_user |
      trained_user_ids.push(trained_user.face_detect_user_id)
    end

    #TODO 起動時に外部からキーを与える    
    client = Face.get_client(api_key: Settings.face_api_key, api_secret: Settings.face_api_secret)

    response = client.faces_recognize(urls: recognize_image_urls,
      uids: trained_user_ids,
      namespace:Settings.face_detect_group_name)
    
    puts response
    
    if response["status"] != "success"
      #TODO binding.pry 消す
      #binding.pry
      return
    end
    
    photos = response["photos"]
    if photos.blank? || photos.count != recognize_photo_mdls.count
      #TODO binding.pry 消す
      #binding.pry
      return
    end

    ActiveRecord::Base.transaction do

      recognize_photo_mdls.each_with_index do | recognize_photo_mdl, i |
        photo = photos[i]
        recognize_photo_mdl.width = photo["width"]
        recognize_photo_mdl.height = photo["height"] 
        if recognize_photo_mdl.save!
          # TODO 修正
          # 保存に成功した場合はユーザ画面へリダイレクト
          #flash[:success] = "編集成功"
        else
          #TODO binding.pry 消す
          #binding.pry
          return
        end
  
    
        tags = photo["tags"]
        if tags.blank? || !tags.any?
          #TODO binding.pry 消す
          #binding.pry
          next
        end
    
        tags.each do | tag |
  
          if tag["recognizable"] == false
            next
          end
    
          detect_face = recognize_photo_mdl.detect_faces.build
          
          detect_face.width = tag["width"]
          detect_face.height = tag["height"]
          detect_face.face_center_x = tag["center"]["x"]
          detect_face.face_center_y = tag["center"]["y"]
          detect_face.save!
          
          recognized_uids = tag["uids"]
          if recognized_uids.blank? || !recognized_uids.any?
            next
          end
          
          recognized_uid = recognized_uids.first
          #TODO 数値検証
          if recognized_uid["confidence"] < 40
            next
          end
        
          confirmed_uid = recognized_uid["uid"].sub(/@#{Settings.face_detect_group_name}$/, "")
          confirmed_user = trained_users.find_by(face_detect_user_id: confirmed_uid)
          if confirmed_user.blank?
            next
          end
        
          group_user = belongs_group.group_users.find_by(user_id: confirmed_user.id)
      
          recognize_note.user_number_sum = recognize_note.user_number_sum | group_user.user_number
          recognize_photo_mdl.user_number_sum =  recognize_photo_mdl.user_number_sum | group_user.user_number
          
          detect_face.user_id = confirmed_user.id
          detect_face.is_recognized = true
      
          recognize_note.save!
          recognize_photo_mdl.save!
          detect_face.save!
          
          new_note_user = recognize_note.related_note_users.find_or_create_by(user_id: confirmed_user.id)
          new_note_user.save!
          new_photo_user = recognize_photo_mdl.related_photo_users.find_or_create_by(user_id: confirmed_user.id)
          new_photo_user.save!
        end
      end
      
    end #ActiveRecord::Base.transaction do
    
    rescue => e
    #binding.pry
      puts e.message

  end
end
