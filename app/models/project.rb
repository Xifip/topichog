class Project < ActiveRecord::Base
  attr_accessible :summary, :title, :tag_list, :content, :reference
  
  has_many :posts, as: :postable, :dependent => :destroy
  has_one :projectdraft, dependent: :destroy
  
#  validates :title, presence: true, length: { maximum: 30 }
#  validates :summary, presence: true, length: { maximum: 140 }
#  validate :validate_tags#, :on => :create
  acts_as_taggable_on :tags
 
  #after_create :add_projectdraft
 
  default_scope order: 'projects.created_at DESC' 
  
  def validate_tags 
    tags_number = self.tag_list.count
    errors.add(:tag_lists, 'you must include at least two tags') unless tags_number > 1
  end

  private

  def add_projectdraft
    self.create_projectdraft
  end  
end
