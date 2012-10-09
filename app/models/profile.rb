class Profile < ActiveRecord::Base
  attr_accessible :bio, :facebook_url, :linkedin_url, :mysite_url, :twitter_url,
                  :myblog_url
  belongs_to :user  
 
  validates :user_id, presence: true
  validates :bio, :allow_blank => true, length: { maximum: 1000 }
  validates_format_of :twitter_url, :allow_blank => true, :with => URI::regexp(%w(http https))
  validates_format_of :facebook_url, :allow_blank => true, :with => URI::regexp(%w(http https))
  validates_format_of :linkedin_url, :allow_blank => true, :with => URI::regexp(%w(http https))
  validates_format_of :mysite_url, :allow_blank => true, :with => URI::regexp(%w(http https))
  validates_format_of :myblog_url, :allow_blank => true, :with => URI::regexp(%w(http https))


end
