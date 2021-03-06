#class AuthenticationsController < Devise::OmniauthCallbacksController
class AuthenticationsController < ApplicationController  
  def index
    @twitter_auth = current_user.authentications.find_by_provider('twitter')
    @facebook_auth = current_user.authentications.find_by_provider('facebook')
    @linkedin_auth = current_user.authentications.find_by_provider('linkedin')        
  end
  
  def all
    #raise request.env["omniauth.auth"].to_yaml
    omni = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omni['provider'], omni['uid'])    
     if authentication
       flash.notice = "Signed in!"      
       sign_in_and_redirect User.find(authentication.user_id), notice: "Signed in!"  
     elsif current_user
       token = omni['credentials'].token
       if omni['provider'] == 'facebook'
        token_secret = ''
        token_expires_at = Time.at(omni.credentials.expires_at)        
       else 
         token_secret = omni['credentials'].secret 
         token_expires_at = ''         
       end  
       current_user.authentications.create!(:provider => omni['provider'], :uid => omni['uid'], :oauth_token => token, :oauth_token_secret => token_secret, :oauth_expires_at => token_expires_at)
       flash[:notice] = "Authentication successful."
       sign_in_and_redirect current_user
     else
       user = User.new
       user.name = omni.info.name
       if omni['provider'] == 'facebook' 
        user.email = omni['extra']['raw_info'].email 
       end 
       if omni['provider'] == 'linkedin'
        user.email = omni['extra']['raw_info'].emailAddress
       end
       user.apply_omniauth(omni)
       if user.save
         flash[:notice] = "Logged in."
         sign_in_and_redirect User.find(user.id)
       else
         session[:omniauth] = omni.except('extra')
         redirect_to new_user_registration_path
       end
     
     end       
  end
  alias_method :twitter, :all
  alias_method :facebook, :all
  alias_method :linkedin, :all  
end
