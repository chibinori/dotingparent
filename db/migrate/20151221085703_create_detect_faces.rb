class CreateDetectFaces < ActiveRecord::Migration
  def change
    create_table :detect_faces do |t|
      t.references :photo, index: true
      t.references :user, index: true
      t.float :width
      t.float :height
      t.float :face_center_x
      t.float :face_center_y
      t.boolean :is_recognized

      t.timestamps null: false
    end
  end
end
