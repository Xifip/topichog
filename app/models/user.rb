class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  has_many :projects, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                    class_name: "Relationship",
                                    dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  
  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false
  
  def project_feed    
    Project.from_users_followed_by(self)
  end
  
  def topic_feed    
    Topic.from_users_followed_by(self)
    #Topic.where("user_id = ?", id)
  end
  
  def feed
    #need to write a proper database read function for this
     proj_feed = Project.from_users_followed_by(self)
     top_feed = Topic.from_users_followed_by(self)
     total_feed = proj_feed + top_feed
     sorted_total_feed = total_feed.sort {|a, b| b.created_at <=> a.created_at}
    #Feed.followed_user_ids = "SELECT followed_id FROM relationships
    #                      WHERE follower_id = :user_id"
    #where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
    #      user_id: user.id)
  end
  
  #def self.from_users_followed_by(user)
  #  followed_user_ids = "SELECT followed_id FROM relationships
  #                        WHERE follower_id = :user_id"
  #  where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
  #        user_id: user.id)
  #end
  
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end
  
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end
  
end
