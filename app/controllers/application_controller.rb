class ApplicationController < ActionController::Base
  
  include HttpAcceptLanguage::AutoLocale

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  include SessionsHelper

  private
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def group_identified_user
    logged_in_user

    belong_groups = current_user.groups
    if belong_groups.count == 1
      session[:group_id] = belong_groups.first.id
    end

    unless group_identified?
    
      store_location
      flash[:info] = "Please select group."
      
      redirect_to group_select_url
    end
  end
end
