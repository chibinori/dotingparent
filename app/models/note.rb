class Note < ActiveRecord::Base
  belongs_to :group
  belongs_to :created_user, class_name: "User"
  
  #Photoとの関連定義
  has_many :photos, dependent: :destroy

end
