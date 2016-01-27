class UserValidator < ActiveModel::Validator
  def validate(record)
    if record.is_admin? && record.email.blank?
      record.errors[:email] << 'email is necessary for admin user!'
    end
  end
end

class User < ActiveRecord::Base
  
  mount_uploader :image_url, UserImageUploader
  
  after_initialize :set_default_value
  before_save { 
    if self.email.blank?
      # 空文字だとユニーク属性にひっかかるためnilにする
      self.email = nil
    end
    if self.email.present?
      self.email = email.downcase
    end
  }
  
  #Groupとの関連定義
  has_many :group_users, class_name: "GroupUser", foreign_key: "user_id", dependent: :destroy
  has_many :groups , through: :group_users, source: :group

  has_many :owns_users, class_name: "User", foreign_key: "owner_user_id"

  #Noteとの関連定義
  has_many :created_notes, class_name: "Note", foreign_key: "created_user_id"

  has_many :related_note_users, class_name: "NoteUser", foreign_key: "user_id", dependent: :destroy
  has_many :related_notes , through: :related_note_users, source: :note

  # このユーザをノートに登場させる
  def regist_related_note(note)
    related_note_users.find_or_create_by(note_id: note.id)
  end
  
  # このユーザをノートから外す
  def release_related_note(note)
    related_note_user = related_note_users.find_by(note_id: note.id)
    related_note_user.destroy if related_note_user
  end
  
  # このユーザがノートに登場しているかどうか？
  def is_related_note?(note)
    related_notes.include?(note)
  end


  has_many :favorite_note_relations, class_name: "FavoriteNote", foreign_key: "user_id", dependent: :destroy
  has_many :favorite_notes , through: :favorite_note_relations, source: :note

  # あるノートをお気に入りにする
  def regist_favorite_note(note)
    favorite_note_relations.find_or_create_by(note_id: note.id)
  end
  
  # あるノートをお気に入りから外す
  def release_favorite_note(note)
    favorite_note_relation = favorite_note_relations.find_by(note_id: note.id)
    favorite_note_relation.destroy if favorite_note_relation
  end
  
  # あるノートをお気に入りにしているかどうか？
  def is_favorite_note?(note)
    favorite_notes.include?(note)
  end
  
  #Photoとの関連定義
  has_many :created_photos, class_name: "Photo", foreign_key: "created_user_id"

  has_many :related_photo_users, class_name: "PhotoUser", foreign_key: "user_id", dependent: :destroy
  has_many :related_photos , through: :related_photo_users, source: :photo

  #PhotoCommentとの関連定義
  has_many :photo_comments, class_name: "PhotoComment", foreign_key: "user_id", dependent: :destroy
  has_many :commented_photos , through: :photo_comments, source: :photo
  #Faceとの関連定義
  has_many :detect_faces

  #
  # 以下バリデーション
  #
  include ActiveModel::Validations
  validates_with UserValidator
  
  validates :login_user_id, presence: true,
                            length: { maximum: 50 },
                            uniqueness: { case_sensitive: true }
  validates :face_detect_user_id, presence: true,
                            length: { maximum: 100 },
                            uniqueness: { case_sensitive: true }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, allow_blank: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password

  validates :first_name, length: { maximum: 50 }
  validates :last_name, length: { maximum: 50 }
  validates :gender, inclusion: { allow_blank: true, in: %w('male' 'female' 'other') }
  validates :nickname, length: { maximum: 50 }
  
  validates :is_admin, inclusion: { in: [true, false] }
  validates :possibe_login, inclusion: { in: [true, false] }
  
  validates :image_width, numericality: {
            allow_blank: true,
            only_integer: true, greater_than: 0
          }
  validates :image_height, numericality: {
            allow_blank: true,
            only_integer: true, greater_than: 0
          }
  validates :image_face_width, numericality: {
            allow_blank: true,
            greater_than: 0.0
          }
  validates :image_face_height, numericality: {
            allow_blank: true,
            greater_than: 0.0
          }
  validates :image_face_center_x, numericality: {
            allow_blank: true,
            greater_than: 0.0
          }
  validates :image_face_center_y, numericality: {
            allow_blank: true,
            greater_than: 0.0
          }

  validates :image_trained, inclusion: { in: [true, false] }
  
  
  private

  def set_default_value
    # 他の必須項目は状況による変更が大きいので、
    # コントローラ側で設定する.
    self.image_trained  ||= false
  end

end
