class LikeMailer < ActionMailer::Base
  default from: "no-reply@topichog.com"
  
  def like_confirmation(liker, liked_post)
    @liker = liker
    @liked_post = liked_post
    
    mail to: liked_post.user.email , subject: liker.name + " liked '" + liked_post.postable.title + "' on TopicHog!"
  end
end
