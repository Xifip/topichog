class Project < ActiveRecord::Base
  attr_accessible :summary, :title
  belongs_to :user
  
  validates :title, presence: true, length: { maximum: 30 }
  validates :summary, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  default_scope order: 'projects.created_at DESC'
end
