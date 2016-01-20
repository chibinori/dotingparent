class AddDisableRecognizeToDetectFaces < ActiveRecord::Migration
  def change
    add_column :detect_faces, :disable_recognize, :boolean
  end
end
