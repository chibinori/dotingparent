class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(create_user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "ユーザー登録が完了しました"
    else
      render 'new'
    end
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end

  def create_user_params
    params.require(:user).permit(:login_user_id, :email, :password,
                                 :password_confirmation)
  end
end
