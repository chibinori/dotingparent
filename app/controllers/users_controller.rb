class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end
  
  # サインアップ画面でのユーザー登録
  def create
    @user = User.new(create_user_params)

    @user.is_admin = true
    @user.possibe_login = true

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
      flash[:success] = "編集成功"
      redirect_to @user
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
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
