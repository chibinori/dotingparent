class AddMovieDataToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :movie_data, :text
  end
end
