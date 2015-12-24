class RenameUrlColumnToPhotos < ActiveRecord::Migration
  def change
    rename_column :photos, :url, :image_data
  end
end
