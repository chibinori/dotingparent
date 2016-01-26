class NotesController < ApplicationController
  require 'face'

  include FaceHelper

  before_action :group_identified_user
  before_action :check_authority
  before_action :set_note, only: [:show, :destroy]

  def new
    @new_note = Note.new
    @new_photo = Photo.new
    @new_photo_comment = PhotoComment.new
  end
  
  def create
    #binding.pry
    ActiveRecord::Base.transaction do
      
      # ノートを作成
      @note = current_group.notes.build(create_note_params)
      @note.created_user_id = current_user.id
      @note.is_active = true
      @note.save!

      @photo = @note.photos.build(create_photo_params)
      @photo.created_user_id = current_user.id
      @photo.is_main = true
      @photo.save!

      @photo_comment = @photo.photo_comments.build(create_photo_comment_params)
      if @photo_comment.comment.present?
        @photo_comment.user_id = current_user.id 
        @photo_comment.save!
      end
      
      recognize_note_photos(@note.id)

      # trained_users = current_group.get_trained_users
      # if !trained_users.any?
      #   redirect_to root_url, success: "写真を登録しました"
      #   return
      # end

      # trained_user_ids = []
      
      # trained_users.each do | trained_user |
      #   trained_user_ids.push(trained_user.face_detect_user_id)
      # end
  
      # #TODO 起動時に外部からキーを与える    
      # client = Face.get_client(api_key: Settings.face_api_key, api_secret: Settings.face_api_secret)
  
      # response = client.faces_recognize(urls: [get_image_url(@photo.image_data)],
      #   uids: trained_user_ids,
      #   namespace:Settings.face_detect_group_name)

      # puts response

      # if response["status"] != "success"
      #   #TODO binding.pry 消す
      #   binding.pry
      #   redirect_to @user
      #   return
      # end
      
      # photos = response["photos"]
      # if photos.blank? || photos.count != 1
      #   #TODO binding.pry 消す
      #   binding.pry
      #   redirect_to @user
      #   return
      # end
      
      # #TODO 複数枚登録対応
      # photo = photos[0]
      # @photo.width = photo["width"]
      # @photo.height = photo["height"] 
      # if @photo.save!
      #   # 保存に成功した場合はユーザ画面へリダイレクト
      #   flash[:success] = "編集成功"
      # else
      #   #TODO binding.pry 消す
      #   binding.pry
      #   redirect_to @user
      #   return
      # end
  
      # tags = photo["tags"]
      # if tags.blank? || !tags.any?
      #   #TODO 写真に２人以上写っている時
      #   #TODO binding.pry 消す
      #   binding.pry
      #   redirect_to @user
      #   return
      # end
      

      # tags.each do | tag |

      #   if tag["recognizable"] == false
      #     next
      #   end

      #   detect_face = @photo.detect_faces.build
        
      #   detect_face.width = tag["width"]
      #   detect_face.height = tag["height"]
      #   detect_face.face_center_x = tag["center"]["x"]
      #   detect_face.face_center_y = tag["center"]["y"]
      #   detect_face.save!
        
      #   recognized_uids = tag["uids"]
      #   if recognized_uids.blank? || !recognized_uids.any?
      #     next
      #   end
        
      #   recognized_uid = recognized_uids.first
      #   #TODO 数値検証
      #   if recognized_uid["confidence"] < 50
      #     next
      #   end
        
      #   confirmed_uid = recognized_uid["uid"].sub(/@#{Settings.face_detect_group_name}$/, "")
      #   confirmed_user = trained_users.find_by(face_detect_user_id: confirmed_uid)
      #   if confirmed_user.blank?
      #     next
      #   end
        
      #   group_user = current_group.group_users.find_by(user_id: confirmed_user.id)

      #   @note.user_number_sum = @note.user_number_sum | group_user.user_number
      #   @photo.user_number_sum =  @photo.user_number_sum | group_user.user_number
        
      #   detect_face.user_id = confirmed_user.id
      #   detect_face.is_recognized = true
        
      #   @note.save!
      #   @photo.save!
      #   detect_face.save!
        
      #   new_note_user = @note.related_note_users.build(user_id: confirmed_user.id)
      #   new_note_user.save!
      #   new_photo_user = @photo.related_photo_users.build(user_id: confirmed_user.id)
      #   new_photo_user.save!
      # end
    end
    
      redirect_to root_url, success: "写真を登録しました"
    
    rescue => e
      puts e.message
      flash[:danger] = "Fail to create note! message:" + e.message
      redirect_to request.referrer || root_url
  end
  
  def index
    
    @notes = current_group.notes.where(is_active: true).order(created_at: :desc)
  end
  
  def admin
    @notes = current_group.notes.where(is_active: true).order(created_at: :desc)
  end

  def show

  end

  def destroy
    
    @note.destroy if @note.present?
    
    redirect_to root_url
  end
  
  def search_form
    @search_note_form = Search::SearchNoteForm.new
  end
  
  def search_index
    
    user_number_sum_val = params[:user_number_sum]
    if user_number_sum_val.present?
      @notes = current_group.notes.where(is_active: true)
        .where("user_number_sum & :user_number_sum = :user_number_sum", user_number_sum: user_number_sum_val.to_i)
        .order(created_at: :desc)
    else
      @specified_user = current_group.users.find_by(login_user_id: params[:login_user_id])
      @notes = @specified_user.related_notes.where(is_active: true).order(created_at: :desc).order(created_at: :desc)
    end

    render 'index'
  end
  

  private
  
  def check_authority
    unless current_group.include_user?(current_user)
      # グループに関係無いユーザが現在のグループにノートを追加しようとしているので
      # ホーム画面へリダイレクト
      flash[:danger] = "Invalid operation detected!"
      redirect_to root_url
    end
  end
  
  
  def create_note_params
    params.require(:note).permit(:title)
  end
  def create_photo_params
    params.require(:photo).permit(:image_data)
  end
  def create_photo_comment_params
    params.require(:photo_comment).permit(:comment)
  end

  def set_note
    @note = Note.find(params[:id])
  end

end
