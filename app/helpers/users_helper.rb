module UsersHelper
# Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "img-polaroid gravatar avatar")
  end
  
  def avatar_for(user, options = { size: 50 })
    twitter_auth = user.authentications.find_by_provider('twitter')
    facebook_auth = user.authentications.find_by_provider('facebook')
    linkedin_auth = user.authentications.find_by_provider('linkedin')   
    
    if user.avatar.image?
      image_tag(user.avatar.image_url(:thumb).to_s, alt: user.name, class: "img-polaroid avatar")
    elsif linkedin_auth
      image_tag(user.linkedin_avatar, alt: user.name, class: "img-polaroid gravatar avatar")    
    elsif twitter_auth
      image_tag(user.twitter_avatar, alt: user.name, class: "img-polaroid gravatar avatar")     
    elsif facebook_auth
      image_tag(user.fb_avatar, alt: user.name, class: "img-polaroid gravatar avatar")     
    else
      gravatar_for user, size: 52
    end  
  end
end
