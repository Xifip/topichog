module UsersHelper
# Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  
  def avatar_for(user, options = { size: 50 })
    if user.avatar.image?
      image_tag(user.avatar.image_url(:thumb).to_s, alt: user.name, class: "img-polaroid")
    else
      gravatar_for user, size: 52
    end  
  end
end
