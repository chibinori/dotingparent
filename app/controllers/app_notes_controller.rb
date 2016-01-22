class AppNotesController < ApplicationController

  protect_from_forgery except: [:create, :update, :movie_image]
  
  before_action :set_note, only: [:show, :update, :movie_image]
  
  def index
    #binding.pry
    
    user_id = params["user_id"]
    
    @user = User.find_by(login_user_id: user_id)
    session[:user_id] = @user.id
    session[:group_id] = @user.groups.first.id
    
    @notes = current_group.notes.where(is_active: true).order(created_at: :desc)
  end
  
  def create

    #binding.pry
    
    user_id = params["user_id"]

    @user = User.find_by(login_user_id: user_id)
    session[:user_id] = @user.id
    session[:group_id] = @user.groups.first.id


    title = params["note_title"]
    comment = params["note_comment"]
    image = params["image"]
    @note = current_group.notes.new
    
    ActiveRecord::Base.transaction do
      
      # ノートを作成
      @note.title = title
      @note.created_user_id = current_user.id
      if image.present?
        # 静止画の登録時は写真はノートに１枚なのでこの時点で、ノートを有効にする
        @note.is_active = true
      end
      @note.save!
      
      @photo = create_and_save_photo(@note)

      if comment.present?
        @photo_comment = @photo.photo_comments.new
        @photo_comment.user_id = current_user.id
        @photo_comment.comment = comment
        @photo_comment.save!
      end

    end

    head :created, location: app_note_url(@note) 
    
  end
  
  def movie_image
    
    finishes = params["finishes"]
    if finishes.present?
      @note.is_active = true
      
      if @note.save
        return head :created
      else
        return head :internal_server_error
      end
    end
    
    user_id = params["user_id"]
    @user = User.find_by(login_user_id: user_id)
    session[:user_id] = @user.id

    @photo = @note.photos.new
    @photo.created_user_id = current_user.id
    @photo.is_main = false

    image = params["movie_image"]
    @photo.image_data = image

    if @photo.save!
      return head :created
    else
      return head :internal_server_error
    end
  end
  
  def show
  end
  
  def update
    #binding.pry    
    
    user_id = params["user_id"]

    @user = User.find_by(login_user_id: user_id)
    session[:user_id] = @user.id

    title = params["note_title"]
    comment = params["note_comment"]
    
    ActiveRecord::Base.transaction do

      # ノートを更新
      @note.title = title
      @note.save!
      
      if comment.present?
        @photo = @note.photos.where(is_main: true).first
        @photo_comment = @photo.photo_comments.find_or_create_by(user_id: current_user.id)
        @photo_comment.comment = comment
        @photo_comment.save!
      end

    end

    head :ok
  end
  
  private
  
  def set_note
    @note = Note.find(params[:id])
  end
  
  def create_and_save_photo(note)

    main_photo = note.photos.new
    main_photo.created_user_id = current_user.id
    main_photo.is_main = true
  
    image = params["image"]
    if image.present?

      main_photo.image_data = image
      main_photo.save!

      return main_photo
    end

    #binding.pry
    movie = params["movie"]
    main_photo.movie_data = movie
    main_photo.is_movie = true
    main_photo.save!
    
    return main_photo
  end
  
end
