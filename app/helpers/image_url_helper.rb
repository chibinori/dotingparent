module ImageUrlHelper
  def get_image_url(image)
    
    if Rails.env.production?
      image.url
    else
      root_url + image.url
    end
  end
end