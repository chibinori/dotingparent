class AddIsMainToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :is_main, :boolean, default: false, null: false
  end
end
