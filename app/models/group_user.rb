class GroupUser < ActiveRecord::Base
  belongs_to :group, class_name: "Group"
  belongs_to :user, class_name: "User"
  validates :user_number, presence: true,
                                  numericality: {
                                    only_integer: true,
                                    greater_than_or_equal_to: Settings.initial_user_number,
                                    even: true
                                  }
end
