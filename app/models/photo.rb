class Photo < ActiveRecord::Base
  belongs_to :note
  belongs_to :created_user, class_name: "User"
  
  #Faceとの関連定義
  has_many :detect_faces, dependent: :destroy

  #Userとの関連定義
  has_many :photo_comments, class_name: "PhotoComment", foreign_key: "photo_id", dependent: :destroy
  has_many :comment_users , through: :photo_comments, source: :user

end
