class Ppost < ActiveRecord::Base
  attr_accessible :title, :summary
  
  has_many :posts, as: :postable
  
  validates :title, presence: true, length: { maximum: 30 }
  validates :summary, presence: true, length: { maximum: 140 }
  
  default_scope order: 'pposts.created_at DESC'
end