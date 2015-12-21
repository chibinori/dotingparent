class GroupsController < ApplicationController
  before_action :logged_in_user
  before_action :set_group, only: [:edit, :update, :destroy, :users]
  
  include UsersHelper

  def new
    check_edit_authority
    
    @group = Group.new
  end
  
  def create
    check_edit_authority
    
    ActiveRecord::Base.transaction do
      
      # グループを作成
      @group = Group.new(create_group_params)
      user_number = @group.current_user_number
      @group.current_user_number = @group.current_user_number * 2

      @group.save!
      
      # 作成したグループとカレントユーザの関連を作成する
      @group_user = GroupUser.new
      @group_user.group_id = @group.id
      @group_user.user_id = current_user.id
      @group_user.user_number = user_number
      # 通常管理者は子供ではないので、検索画面で中央表示にしないようfalseにする
      @group_user.is_center_displayed = false
      
      @group_user.save!
    end
    
      redirect_to groups_user_path(current_user), success: "グループ登録が完了しました"
    
    rescue => e
      flash[:danger] = "Fail to create group! message:" + e.message
      redirect_to request.referrer || root_url
  end
  
  def edit
    check_edit_authority
    @new_user = User.new
    @new_group_user = GroupUser.new
  end
  
  def update
    #binding.pry
    
    check_edit_authority
    
    if @group.update(update_group_params)
      # 保存に成功した場合はグループ画面へリダイレクト
      flash[:success] = "編集成功"
      
      redirect_to groups_user_path(current_user), success: "グループ編集が完了しました"
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end
  
  def users
    
    check_edit_authority
    ActiveRecord::Base.transaction do
      
      # グループ情報を更新
      user_number = @group.current_user_number
      @group.current_user_number = @group.current_user_number * 2

      @group.save!
      
      # ユーザを作成する
      @user = User.new(create_user_params)
      @user.is_admin = false
      #この値は保存してから一度も変わることは無い
      @user.face_detect_user_id = create_face_detect_user_id(@user)
      @user.owner_user_id = current_user.id
      @user.save!
      
      # グループと追加するユーザの関連を作成する
      @group_user = GroupUser.new(create_group_user_params)
      @group_user.group_id = @group.id
      @group_user.user_id = @user.id
      @group_user.user_number = user_number
      @group_user.is_center_displayed = false
      if @group_user.family_relation == "child"
        @group_user.is_center_displayed = true
      end
      
      @group_user.save!
    end
    
      redirect_to request.referrer || root_url
    
    rescue => e
      flash[:danger] = "Fail to create group! message:" + e.message
      redirect_to request.referrer || root_url
    
  end
  
  def destroy
    
    check_edit_authority
    
    if current_group == @group
      session[:group_id] = nil
    end
    @group.destroy if @group.present?
    
    redirect_to request.referrer || root_url
  end

  
  private
  def create_group_params
    params.require(:group).permit(:name)
  end
  def update_group_params
    create_group_params
  end
  
  def check_edit_authority
    if !current_user.is_admin?
      # 管理者でないユーザがグループ情報を編集しようとしているので
      # ホーム画面へリダイレクト
      flash[:danger] = "Invalid operation detected!"
      redirect_to root_url
    end
    
    if @group.present? && !@group.include_user?(current_user)
      # グループに関係無いユーザがグループ情報を編集しようとしているので
      # ホーム画面へリダイレクト
      flash[:danger] = "Invalid operation detected!"
      redirect_to root_url
    end
  end
  
  def set_group
    @group = Group.find(params[:id])
  end
  
  # email設定は管理者と異なり無い
  def create_user_params
    params.require(:user).permit(:login_user_id, :password,
                                 :password_confirmation,
                                 :possibe_login)
  end
  def create_group_user_params
    params.require(:group_user).permit(:family_relation)
  end
end
