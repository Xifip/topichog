class Post < ActiveRecord::Base
   attr_accessible :postable_id, :postable_type
  belongs_to :user
  belongs_to :postable, polymorphic: true
  
  validates :user_id, presence: true
  validates :postable_id, presence: true
  validates :postable_type, presence: true
  default_scope order: 'posts.created_at DESC'
  
end
