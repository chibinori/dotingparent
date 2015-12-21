module UsersHelper
  def user_image_for(user, options = { size: 80 })
    size = options[:size]
    image_tag(user.image_url, alt: user.login_user_id, width: size, height: size, class: "user_image")
  end
  
  def create_face_detect_user_id(user)
    user.login_user_id + Time.now.strftime("%Y%m%d%H%M%S")
  end
end
