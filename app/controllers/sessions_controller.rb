class SessionsController < ApplicationController
  def new
  end

  def create
    #binding.pry
    @user = User.find_by(login_user_id: params[:session][:login_user_id_or_email].downcase)
    if @user.blank?
      @user = User.find_by(email: params[:session][:login_user_id_or_email].downcase)
    end
    
    if @user.present? && @user.possibe_login? && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      flash[:info] = "logged in as #{@user.login_user_id}"
      redirect_to root_path
    else
      flash[:danger] = 'invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    session[:user_id] = nil
    session[:group_id] = nil
    redirect_to root_path
  end
end
