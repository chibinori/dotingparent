class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :note, index: true
      t.references :created_user, index: true
      t.integer :user_number_sum
      t.text :url
      t.integer :width
      t.integer :height
      t.boolean :is_detected

      t.timestamps null: false
    end
  end
end
