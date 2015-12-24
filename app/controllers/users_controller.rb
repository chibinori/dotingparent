class UsersController < ApplicationController
  require 'face'
  include UsersHelper

  before_action :set_user, only: [:show, :edit, :update, :destroy, :groups]
  

  def new
    @user = User.new
  end
  
  # サインアップ画面でのユーザー登録
  def create
    @user = User.new(create_user_params)

    @user.is_admin = true
    @user.possibe_login = true
    
    #この値は保存してから一度も変わることは無い
    @user.face_detect_user_id = create_face_detect_user_id(@user)
    
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "ユーザー登録が完了しました"
    else
      render 'new'
    end
  end
  
  def show
  end
  
  def edit
    check_edit_authority
  end
  
  def update
    #binding.pry
    
    check_edit_authority
    
    if @user.update(update_user_params)
      # 保存に成功した場合はユーザ画面へリダイレクト
      # TODO メッセージ
      #flash[:success] = "編集成功"
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
    
    if @user.image_url.blank?
      flash[:success] = "編集成功"
      redirect_to @user
      return
    end

    #if @user.image_trained?
    #  flash[:success] = "編集成功"
    #  redirect_to @user
    #  return
    #end

    #binding.pry

    #TODO 起動時に外部からキーを与える    
    client = Face.get_client(api_key: Settings.face_api_key, api_secret: Settings.face_api_secret)

    if Rails.env.production?
      response = client.faces_detect(urls: [@user.image_url.url])
    else
      # この時点では@photo.photo_image.urlを受け付けられないため
      imagefile = File.new(@user.image_url.file.file, 'rb')
      response = client.faces_detect(file: imagefile)
    end
    
    if response["status"] != "success"
      #TODO binding.pry 消す
      binding.pry
      redirect_to @user
      return
    end
    
    photos = response["photos"]
    if photos.blank? || photos.count != 1
      #TODO binding.pry 消す
      binding.pry
      redirect_to @user
      return
    end
    
    photo = photos[0]
    @user.image_width = photo["width"]
    @user.image_height = photo["height"] 
    if @user.save
      # 保存に成功した場合はユーザ画面へリダイレクト
      flash[:success] = "編集成功"
    else
      #TODO binding.pry 消す
      binding.pry
      redirect_to @user
      return
    end

    tags = photo["tags"]
    if tags.blank? || tags.count != 1
      #TODO 写真に２人以上写っている時
      #TODO binding.pry 消す
      binding.pry
      redirect_to @user
      return
    end
    
    tag = tags[0]
    if tag["recognizable"] == false
      #TODO binding.pry 消す
      binding.pry
      redirect_to @user
      return
    end
    
    tid = tag["tid"]
    face_detect_uid = @user.face_detect_user_id + "@" + Settings.face_detect_group_name
    response = client.tags_save(uid: face_detect_uid, tids: [tid])

    if response["status"] != "success"
      #TODO binding.pry 消す
      binding.pry
      redirect_to @user
      return
    end

    response = client.faces_train(uids: [face_detect_uid])

    if response["status"] != "success"
      #TODO binding.pry 消す
      binding.pry
      redirect_to @user
      return
    end
    
    @user.image_face_width = tag["width"]
    @user.image_face_height = tag["height"]
    @user.image_face_center_x = tag["center"]["x"]
    @user.image_face_center_y = tag["center"]["y"]
    @user.image_trained = true

    if @user.save
      # 保存に成功した場合はユーザ画面へリダイレクト
      flash[:success] = "編集成功"
    else
      #TODO binding.pry 消す
      binding.pry
      redirect_to @user
      return
    end


    redirect_to @user
  end
  
  def destroy
    
    check_edit_authority
    
    if current_user == @user
      session[:user_id] = nil
    end
    @user.destroy
    
    redirect_to root_url
  end
  
  def groups
    unless @user.groups.any?
      redirect_to new_group_path, notice: "グループを作成してください。"
    end


  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def check_edit_authority
    if @user != current_user && !current_user.is_admin?
      # ログイン中のユーザではないユーザ情報を編集しようとしているので
      # ホーム画面へリダイレクト(管理者は除く)
      flash[:danger] = "Invalid operation detected!"
      redirect_to root_url
    end
  end

  def create_user_params
    params.require(:user).permit(:login_user_id, :email, :password,
                                 :password_confirmation)
  end

  def update_user_params
    params.require(:user).permit(:login_user_id, :email, :password,
                                 :password_confirmation, :image_url)
  end

end
