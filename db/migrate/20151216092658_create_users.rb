class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :login_user_id
      t.string :password_digest
      t.string :gender
      t.string :nickname
      t.boolean :is_admin
      t.boolean :possibe_login
      t.text :image_url
      t.integer :image_width
      t.integer :image_height
      t.float :image_face_width
      t.float :image_face_height
      t.float :image_face_center_x
      t.float :image_face_center_y
      t.boolean :image_trained

      t.timestamps null: false
      
      t.index :email, unique: true
      t.index :login_user_id, unique: true
    end
  end
end
