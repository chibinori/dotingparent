module ImageUrlHelper
  def get_image_url(image)
    
    if Rails.env.production?
      image.url
    else
      root_url_length = root_url.length
      temp_root_url = root_url.slice(0, root_url_length - 1)
      temp_root_url + image.url
    end
  end
end