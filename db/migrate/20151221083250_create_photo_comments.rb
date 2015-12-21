class CreatePhotoComments < ActiveRecord::Migration
  def change
    create_table :photo_comments do |t|
      t.references :photo, index: true
      t.references :user, index: true
      t.text :comment

      t.timestamps null: false
      
      t.index [:photo_id, :user_id], unique: true

    end
  end
end
