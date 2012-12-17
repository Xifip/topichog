class Authentication < ActiveRecord::Base
  
  attr_accessible :provider, :uid, :oauth_token, :oauth_token_secret, :oauth_expires_at
  belongs_to :user
  
  after_create :use_connection_bio
  
  def use_connection_bio
    if self.user.profile != nil
      user = self.user
      bio = user.profile.bio
      provider = self.provider
      
      if bio == nil || bio.length == 0
        if provider == 'facebook'
          user.profile.update_attributes(bio: user.facebook.get_object("me")["bio"])      
        end
        
        if provider == 'twitter' 
          client = Twitter::Client.new(
            :oauth_token => self.oauth_token,
            :oauth_token_secret => self.oauth_token_secret
          ) 
          user.profile.update_attributes(bio: client.user(Integer(self.uid)).description)
        end
        
        if provider == 'linkedin'
          client = LinkedIn::Client.new(ENV["LINKEDIN_CONSUMER_KEY"], ENV["LINKEDIN_CONSUMER_SECRET"])
          client.authorize_from_access(self.oauth_token, self.oauth_token_secret)  
          linkedin_bio = client.profile(:fields => %w(summary)).summary
          user.profile.update_attributes(bio: linkedin_bio )  
        end
      end  
    end  
  end  
  
end
