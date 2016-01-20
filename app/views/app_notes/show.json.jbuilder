
json.extract! @note, :id, :title, :created_at
photo = @note.photos.first
json.image_url get_image_url(photo.image_data)
json.comments do
  json.array!(photo.photo_comments) do | comment |
    json.comment comment.comment
    json.user_image_url get_image_url(comment.user.image_url)
  end
end
