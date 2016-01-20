class Photo < ActiveRecord::Base
  belongs_to :note
  belongs_to :created_user, class_name: "User"

  mount_uploader :image_data, PhotoUploader
  mount_uploader :movie_data, MovieUploader
  
  #Faceとの関連定義
  has_many :detect_faces, dependent: :destroy

  #Userとの関連定義
  has_many :photo_comments, class_name: "PhotoComment", foreign_key: "photo_id", dependent: :destroy
  has_many :comment_users , through: :photo_comments, source: :user

  has_many :related_photo_users, class_name: "PhotoUser", foreign_key: "photo_id", dependent: :destroy
  has_many :related_users , through: :related_photo_users, source: :user

  after_initialize :set_default_value
  
  #
  # 以下バリデーション
  #
  validates :user_number_sum, presence: true,
                                  numericality: {
                                    only_integer: true,
                                    greater_than_or_equal_to: 0,
                                  }

  validates :width, numericality: {
            allow_blank: true,
            only_integer: true, greater_than: 0
          }
  validates :height, numericality: {
            allow_blank: true,
            only_integer: true, greater_than: 0
          }

  validates :is_detected, inclusion: { in: [true, false] }
  validates :is_movie, inclusion: { in: [true, false] }
  
  private

  def set_default_value
    self.is_detected  ||= false
    self.is_movie  ||= false
    self.user_number_sum  ||= 0
  end

end
