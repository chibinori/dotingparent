class SessionsController < ApplicationController
  def new
  end

  def create

    @user = User.find_by(login_user_id: params[:session][:login_user_id_or_email].downcase)
    if @user.blank?
      @user = User.find_by(email: params[:session][:login_user_id_or_email].downcase)
    end
    
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      flash[:info] = "logged in as #{@user.name}"
      redirect_to @user
    else
      flash[:danger] = 'invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
