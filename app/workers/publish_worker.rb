class PublishWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform(user_id, post_url)
    user = User.find(user_id)
    user.facebook.put_connections("me", "topichog:review", movie: post_url)
  end
end
