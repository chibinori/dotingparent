class AddIsMovieToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :is_movie, :boolean
  end
end
