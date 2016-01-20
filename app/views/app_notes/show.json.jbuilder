
json.extract! @note, :id, :title, :created_at
photo = @note.photos.where(is_movie: false).first
json.image_url get_image_url(photo.image_data)
movie = @note.photos.where(is_movie: true).first
if movie.present?
  json.movie_url get_image_url(movie.movie_data)
end
json.comments do
  json.array!(photo.photo_comments) do | comment |
    json.comment comment.comment
    json.user_image_url get_image_url(comment.user.image_url)
  end
end
