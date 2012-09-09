class Post < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :postable, polymorphic: true
  
  validates :user_id, presence: true
  validates :postable_id, presence: true
  validates :postable_type, presence: true
  default_scope order: 'posts.created_at DESC'
  
end
