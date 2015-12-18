module SessionsHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
  
  def current_group
    @current_group ||= Group.find_by(id: session[:group_id])
  end

  def group_identified?
    !!current_group
  end
end
