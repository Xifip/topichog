module ProjectsHelper
# Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_url_for(user, options = { size: 50 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  end
  
  def projectdraftimage_for(project)
    
    user = project.posts.first.user

    twitter_auth = user.authentications.find_by_provider('twitter')
    facebook_auth = user.authentications.find_by_provider('facebook')
    linkedin_auth = user.authentications.find_by_provider('linkedin')   
    
    if user.avatar.image?
      user.avatar.image_url(:thumb).to_s
    elsif linkedin_auth
      user.linkedin_avatar   
    elsif twitter_auth
      user.twitter_avatar    
    elsif facebook_auth
      user.fb_avatar    
    else
      gravatar_url_for user, size: 52
    end  
  end
end
