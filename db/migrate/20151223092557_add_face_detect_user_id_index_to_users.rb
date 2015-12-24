class AddFaceDetectUserIdIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :face_detect_user_id, unique: true
  end
end
