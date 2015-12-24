class DetectFace < ActiveRecord::Base
  belongs_to :photo
  belongs_to :user
  
  after_initialize :set_default_value

  #
  # 以下バリデーション
  #
  validates :width, numericality: {
            allow_blank: true,
            greater_than: 0.0
          }
  validates :height, numericality: {
            allow_blank: true,
            greater_than: 0.0
          }
  validates :face_center_x, numericality: {
            allow_blank: true,
            greater_than: 0.0
          }
  validates :face_center_y, numericality: {
            allow_blank: true,
            greater_than: 0.0
          }

  validates :is_recognized, inclusion: { in: [true, false] }

  def set_default_value
    self.is_recognized  ||= false
  end

end
