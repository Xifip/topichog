class Profile < ActiveRecord::Base
  attr_accessible :bio, :facebook_url, :image, :linkedin_url, :mystire_url, :twitter_url,
                    :crop_x, :crop_y, :crop_w, :crop_h
  belongs_to :user
  
  mount_uploader :image, ImageUploader
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :crop_image
  
  def crop_image
    image.recreate_versions! if crop_x.present?
  end
  
  validates :user_id, presence: true
  validates :bio, :allow_blank => true, length: { maximum: 1000 }
  validates_format_of :twitter_url, :allow_blank => true, :with => URI::regexp(%w(http https))
  validates_format_of :facebook_url, :allow_blank => true, :with => URI::regexp(%w(http https))
  validates_format_of :linkedin_url, :allow_blank => true, :with => URI::regexp(%w(http https))
  validates_format_of :mysite_url, :allow_blank => true, :with => URI::regexp(%w(http https))


end
