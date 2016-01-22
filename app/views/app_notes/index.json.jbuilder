json.array!(@notes) do | note |

  json.extract! note, :id, :title, :created_at
  json.thumbnail get_image_url(note.photos.where(is_movie: false).first.image_data.thumb)
  main_photo = note.photos.where(is_main: true).first
  json.is_movie main_photo.is_movie
  json.url app_note_url(note, format: :json)
end
