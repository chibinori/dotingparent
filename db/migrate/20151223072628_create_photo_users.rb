class CreatePhotoUsers < ActiveRecord::Migration
  def change
    create_table :photo_users do |t|
      t.references :photo, index: true
      t.references :user, index: true

      t.timestamps null: false

      t.index [:photo_id, :user_id], unique: true
    end
  end
end
