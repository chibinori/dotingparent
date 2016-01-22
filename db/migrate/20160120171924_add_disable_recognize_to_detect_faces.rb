class AddDisableRecognizeToDetectFaces < ActiveRecord::Migration
  def change
    add_column :detect_faces, :disable_recognize, :boolean, default: false, null: false
  end
end
