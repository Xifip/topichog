class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :token_authenticatable
  
  before_save :ensure_authentication_token
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, 
    :remember_me, :profile_attributes
  
  # attr_accessible :title, :body
  has_one :user_preference, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :projectdrafts, dependent: :destroy
  has_many :topicdrafts, dependent: :destroy  
  has_one :profile, dependent: :destroy
  has_one :avatar, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                    class_name: "Relationship",
                                    dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  
 #likes
  has_many :likes, foreign_key: "liker_id", dependent: :destroy
  has_many :liked_posts, :through => :likes, :source => :liked, 
          :class_name => "Post"
  has_many :topicdraftimages, dependent: :destroy
  has_many :projectdraftimages, dependent: :destroy
  acts_as_tagger
  after_create :add_preferences
  after_create :add_profile
  after_create :add_avatar
  accepts_nested_attributes_for :profile  
  validates_presence_of :name
  validates_uniqueness_of :email, :case_sensitive => false
      
  def project_drafts_ahead
    Projectdraft.projectdrafts_unpublished_from(self)
  end
  
  def topic_drafts_ahead
    Topicdraft.topicdrafts_unpublished_from(self)
  end
  
  def project_feed    
    Post.projects_from_users_followed_by(self)#.find_by_postable_type("project")
  end
  
  def topic_feed    
    Post.topics_from_users_followed_by(self)#.find_by_postable_type("topic")
  end
  
  def feed
    Post.from_users_followed_by(self)
  end  

  
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end
  
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end
  
  def liking?(post)
    likes.find_by_liked_id(post.id)
  end
  
  def like!(post)
    likes.create!(liked_id: post.id)
  end
  
  def unlike!(post)
    likes.find_by_liked_id(post.id).destroy
  end
  
   private

  def add_preferences
    self.create_user_preference(mail_on_follower_post: true,
    mail_on_follower: true,
    mail_monthly_update: true,
    mail_new_features: true,
    mail_on_liker: true)
  end
  
  def add_profile
    self.create_profile
  end
  
  def add_avatar
    self.create_avatar
  end
end
