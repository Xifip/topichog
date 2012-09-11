class Project < ActiveRecord::Base
  attr_accessible :summary, :title
  
  has_many :posts, as: :postable, :dependent => :destroy
  
  validates :title, presence: true, length: { maximum: 30 }
  validates :summary, presence: true, length: { maximum: 140 }

  default_scope order: 'projects.created_at DESC' 
end
