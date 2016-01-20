json.array!(@notes) do | note |

  json.extract! note, :id, :title, :created_at
  json.thumbnail get_image_url(note.photos.where(is_movie: false).first.image_data.thumb)
  json.url app_note_url(note, format: :json)
end
