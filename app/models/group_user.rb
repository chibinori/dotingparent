class GroupUser < ActiveRecord::Base
  belongs_to :group, class_name: "Group"
  belongs_to :user, class_name: "User"
  
  #
  # 以下バリデーション
  #

  validates :is_center_displayed, inclusion: { in: [true, false] }
#  validates :family_relation, inclusion: { allow_blank: true, in: %w('child' 'father' 'mother' 'grandfather' 'grandmother' 'other') }

  validates :user_number, presence: true,
                                  numericality: {
                                    only_integer: true,
                                    greater_than_or_equal_to: Settings.initial_user_number,
                                    even: true
                                  }
end
