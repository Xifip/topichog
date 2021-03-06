class Post < ActiveRecord::Base
   attr_accessible :postable_id, :postable_type
  belongs_to :user
  belongs_to :postable, polymorphic: true
  acts_as_taggable_on :tags
  
  #likes
  has_many :likes, :foreign_key => "liked_id", :dependent => :destroy
  has_many :likers, :through => :likes, :source => :liker, 
    :class_name => "User"  
     
  validates :user_id, presence: true
  validates :postable_id, presence: true
  validates :postable_type, presence: true
  
  default_scope order: 'posts.created_at DESC'  
 
    
  def likes_count 
    likes.count
  end
  
  def self.project_with_postable_id(postable_id)
    where("postable_type = ? AND postable_id = ?", "Project", postable_id).first
  end
  
  def self.topic_with_postable_id(postable_id)
    where("postable_type = ? AND postable_id = ?", "Topic", postable_id).first
  end
  
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                          WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
  
  def self.topics_from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                          WHERE follower_id = :user_id"
    where("(user_id IN (#{followed_user_ids}) OR user_id = :user_id) AND (postable_type = 'Topic')",
          user_id: user.id)
  end
  
  def self.topics_from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                          WHERE follower_id = :user_id"
    where("(user_id IN (#{followed_user_ids}) OR user_id = :user_id) AND (postable_type = 'Topic')",
          user_id: user.id)
  end
  
  def self.projects_from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                          WHERE follower_id = :user_id"
    where("(user_id IN (#{followed_user_ids}) OR user_id = :user_id) AND (postable_type = 'Project')",
          user_id: user.id)
  end
end
