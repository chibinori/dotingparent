class PhotoComment < ActiveRecord::Base
  belongs_to :photo
  belongs_to :user

  #
  # 以下バリデーション
  #
  validates :comment, presence: true,
                            length: { maximum: 100 }

end
