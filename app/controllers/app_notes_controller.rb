class AppNotesController < ApplicationController

  protect_from_forgery except: [:create, :update]
  
  before_action :set_note, only: [:show, :update]
  
  def index
    #binding.pry
    
    @user = User.find_by(login_user_id: 'papa')
    session[:user_id] = @user.id
    session[:group_id] = @user.groups.first.id
    
    @notes = current_group.notes.order(created_at: :desc)
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

    ActiveRecord::Base.transaction do
      
      # ノートを作成
      @note = current_group.notes.new
      @note.title = title
      @note.created_user_id = current_user.id
      @note.save!
      
      @photo = @note.photos.new
      @photo.image_data = image
      @photo.created_user_id = current_user.id
      @photo.save!

      if comment.present?
        @photo_comment = @photo.photo_comments.new
        @photo_comment.user_id = current_user.id
        @photo_comment.comment = comment
        @photo_comment.save!
      end

    end

    head :created, location: product_path(@note) 
    
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
      
      @photo = @note.photos.first

      if comment.present?
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
  
end
