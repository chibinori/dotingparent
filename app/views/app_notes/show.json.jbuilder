
json.extract! @note, :id, :title, :created_at
photo_for_image = @note.photos.where(is_movie: false).first
json.image_url get_image_url(photo_for_image.image_data)
main_photo = @note.photos.where(is_main: true).first
if main_photo.is_movie?
  json.movie_url get_image_url(main_photo.movie_data)
end

json.comments do
  json.array!(main_photo.photo_comments.order(created_at: :asc)) do | comment |
    json.comment comment.comment
    json.user_image_url get_image_url(comment.user.image_url)
  end
end
