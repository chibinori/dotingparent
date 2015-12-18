module UsersHelper
  def user_image_for(user, options = { size: 80 })
    size = options[:size]
    image_tag(user.image_url, alt: user.login_user_id, width: size, height: size, class: "user_image")
  end
end
