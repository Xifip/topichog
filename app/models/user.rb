class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  
  devise :database_authenticatable, :registerable, :omniauthable,
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
  has_many :authentications
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
  

=begin
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      if auth.provider == "facebook"
        user.name = auth.info.name
        user.email = auth.info.email
        user.oauth_token = auth.credentials.token
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      elsif auth.provider == "twitter"  
        user.oauth_token = auth.credentials.token
        user.oauth_secret = auth.credentials.secret
        user.name = auth.info.name
      elsif auth.provider == "linkedin"  
        user.oauth_token = auth.credentials.token
        user.oauth_secret = auth.credentials.secret
        user.name = auth.info.name      
        user.email = auth.info.email  
      end
    end
  end  
=end

  def apply_omniauth(omni)

   if omni.provider != 'facebook'
    oauth_expires_at = nil
   else
    oauth_expires_at = Time.at(omni['credentials'].expires_at)
   end 
   authentications.build(:provider => omni['provider'],
   :uid => omni['uid'],
   :oauth_token => omni['credentials'].token,
   :oauth_token_secret => omni['credentials'].secret,
   :oauth_expires_at => oauth_expires_at)
  end
  
  def facebook
    authentication = Authentication.find_by_provider_and_user_id('facebook', self.id)  
    @facebook ||= Koala::Facebook::API.new(authentication.oauth_token)
  end
  
  def fb_avatar
    'http://graph.facebook.com/' + self.facebook.get_object("me")["id"] + '/picture' 
  end
  
  def twitter_avatar
    authentication = Authentication.find_by_provider_and_user_id('twitter', self.id) 
    client = Twitter::Client.new(
        :oauth_token => authentication.oauth_token,
        :oauth_token_secret => authentication.oauth_secret
      )   
        
     image_url = client.user(Integer(authentication.uid)).profile_image_url
  end
  
  def linkedin_avatar
    authentication = Authentication.find_by_provider_and_user_id('linkedin', self.id) 
    client = LinkedIn::Client.new(ENV["LINKEDIN_CONSUMER_KEY"], ENV["LINKEDIN_CONSUMER_SECRET"])
    client.authorize_from_access(authentication.oauth_token, authentication.oauth_secret)
    
    client.profile(:fields => %w(picture-url)).picture_url
  end
  
  def self.new_with_session(params, session)

    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end    
  end   

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end  
    
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
      
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
    if self.provider == 'facebook'
      self.profile.update_attributes(bio: self.facebook.get_object("me")["bio"])      
    end
    
    if self.provider == 'twitter'
      authentication = Authentication.find_by_provider_and_user_id('twitter', self.id)  
      client = Twitter::Client.new(
        :oauth_token => authentication.oauth_token,
        :oauth_token_secret => authentication.oauth_secret
      ) 
      self.profile.update_attributes(bio: client.user(Integer(authentication.uid)).description)
    end
    
    if self.provider == 'linkedin'
      authentication = Authentication.find_by_provider_and_user_id('linkedin', self.id)  
      client = LinkedIn::Client.new(ENV["LINKEDIN_CONSUMER_KEY"], ENV["LINKEDIN_CONSUMER_SECRET"])
      client.authorize_from_access(authentication.oauth_token, authentication.oauth_secret)  
      linkedin_bio = client.profile(:fields => %w(summary)).summary
      self.profile.update_attributes(bio: linkedin_bio )  
    end
       
  end
  
  def add_avatar
    self.create_avatar
  end
end
