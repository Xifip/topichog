class Project < ActiveRecord::Base
  attr_accessible :summary, :title, :tag_list, :content, :reference
  
  has_many :posts, as: :postable, :dependent => :destroy
  has_one :projectdraft, dependent: :destroy
  
  acts_as_taggable_on :tags
 
  default_scope order: 'projects.created_at DESC' 

end
