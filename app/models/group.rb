class Group < ActiveRecord::Base
  
  after_initialize :set_default_value

  
  #Userとの関連定義
  has_many :group_users, class_name: "GroupUser", foreign_key: "group_id", dependent: :destroy
  has_many :users , through: :group_users, source: :user

  #Noteとの関連定義
  has_many :notes, dependent: :destroy
  
  #指定したユーザーをこのグループに追加する
  def add_user(user)
    group_users.find_or_create_by(user_id: user.id)
  end

  #指定したユーザーをこのグループから削除する
  def remove_user(user)
    group_users.find_by(user_id: user.id).destroy
  end

  #指定したユーザーがこのグループ内に存在するかどうか
  def include_user?(user)
    users.include?(user)
  end
  
  def get_trained_users
    users.where(image_trained: true)
  end
  
  #
  # 以下バリデーション
  #
  validates :name, presence: true,
                            length: { maximum: 50 }
  validates :current_user_number, presence: true,
                                  numericality: {
                                    only_integer: true,
                                    greater_than_or_equal_to: Settings.initial_user_number,
                                    even: true
                                  }
                                  
  private

  def set_default_value
    self.current_user_number  ||= Settings.initial_user_number
  end
end
