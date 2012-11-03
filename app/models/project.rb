class Project < ActiveRecord::Base
  attr_accessible :summary, :title, :tag_list, :content, :reference, :image
  
  has_many :posts, as: :postable, :dependent => :destroy
  has_one :projectdraft, dependent: :destroy
  has_many :projectdraftimages, dependent: :destroy
  
  acts_as_taggable_on :tags
  
  mount_uploader :image, ProjectdraftimageUploader
 
  default_scope order: 'projects.created_at DESC' 

end
