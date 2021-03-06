class Avatar < ActiveRecord::Base
  attr_accessible :image,:crop_x, :crop_y, :crop_w, :crop_h
  belongs_to :user
  
  mount_uploader :image, AvatarUploader
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :crop_avatar
  
  def crop_avatar
    #debugger
    image.recreate_versions! if crop_x.present?
  end
  
  validates :user_id, presence: true

end
