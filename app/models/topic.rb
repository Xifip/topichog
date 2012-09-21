class Topic < ActiveRecord::Base
  attr_accessible :summary, :title, :tag_list
  
  has_many :posts, as: :postable, :dependent => :destroy
  
  validates :title, presence: true, length: { maximum: 30 }
  validates :summary, presence: true, length: { maximum: 140 }
  #validate :validate_tags
  acts_as_taggable_on :tags
  
  default_scope order: 'topics.created_at DESC'
  
  def validate_tags    
    tags_number = self.tag_list.count
    errors.add(:tag_lists, 'you must include at least two tags') unless tags_number > 1
  end
end
