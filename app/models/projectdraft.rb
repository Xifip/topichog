class Projectdraft < ActiveRecord::Base
  attr_accessible :summary, :title, :tag_list, :content, :reference,:draft_ahead
  
  acts_as_taggable_on :tags
    
  belongs_to :project
  belongs_to :user
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 30 }
  validates :summary, presence: true, length: { maximum: 140 }
  validate :validate_tags#, :on => :create
  
  default_scope order: 'projectdrafts.created_at DESC' 

  
   def validate_tags
    #debugger
    tags_number = self.tag_list.count
    errors.add(:tag_lists, 'you must include at least two tags') unless tags_number > 1
  end
  

end
