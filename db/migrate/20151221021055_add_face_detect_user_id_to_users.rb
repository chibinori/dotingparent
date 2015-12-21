class AddFaceDetectUserIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :face_detect_user_id, :string
  end
end
