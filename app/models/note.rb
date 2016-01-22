class Note < ActiveRecord::Base
  belongs_to :group
  belongs_to :created_user, class_name: "User"
  
  #Photoとの関連定義
  has_many :photos, dependent: :destroy
  
  #Userとの関係
  has_many :related_note_users, class_name: "NoteUser", foreign_key: "note_id", dependent: :destroy
  has_many :related_users , through: :related_note_users, source: :user
  

  after_initialize :set_default_value

  #
  # 以下バリデーション
  #
  validates :title, presence: true,
                            length: { maximum: 50 }
  validates :user_number_sum, presence: true,
                                  numericality: {
                                    only_integer: true,
                                    greater_than_or_equal_to: 0,
                                  }
  validates :is_active, inclusion: { in: [true, false] }

  private

  def set_default_value
    self.user_number_sum  ||= 0
    self.is_active  ||= false
  end

end
