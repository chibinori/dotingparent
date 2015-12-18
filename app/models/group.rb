class Group < ActiveRecord::Base
  validates :name, presence: true,
                            length: { maximum: 50 }
  validates :current_user_number, presence: true,
                                  numericality: {
                                    only_integer: true,
                                    greater_than_or_equal_to: Settings.initial_user_number,
                                    even: true
                                  }
end
