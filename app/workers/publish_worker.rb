class PublishWorker
  include Sidekiq::Worker
  sidekiq_options retry: true
  
  def perform(user_id, post_url, postable_id, postable_type, linkedin_publicise, facebook_publicise, twitter_publicise, has_image)
    user = User.find(user_id)
    
    if postable_type == "Topic"
      postable = Topic.find(postable_id)
    elsif postable_type == "Project"
      postable = Project.find(postable_id)
    end
    
    twitter_auth = user.authentications.find_by_provider('twitter')
    facebook_auth = user.authentications.find_by_provider('facebook')
    linkedin_auth = user.authentications.find_by_provider('linkedin') 
    
    if facebook_auth && facebook_publicise
     user.facebook.put_connections("me", "topichog:post", article: post_url)
    end
    
    if twitter_auth && twitter_publicise
      Bitly.use_api_version_3
      bitly_client = Bitly.new( ENV["bitly_Username"], ENV["bitly_API_Key"])
      post_url = bitly_client.shorten(post_url).short_url
      char_count = (postable.title + ': ' + post_url+ ' via: @topichog').length
      tag0 = ' #' + postable.tag_list[0].gsub(/\s+/, "")
      tag1 = ' #' + postable.tag_list[1].gsub(/\s+/, "")    
      
      if tag0 <= tag1
        shorter_tag = tag0
        longer_tag = tag1   
      elsif
        shorter_tag = tag1 
        longer_tag = tag0
      end
          
      if (shorter_tag.length + char_count) >= 140
        shorter_tag = ''
        longer_tag = ''
      end  

      if (shorter_tag.length + longer_tag.length + char_count) >= 140
        longer_tag = ''
      end  
            
      tweet_text = postable.title + ': ' + post_url + shorter_tag + longer_tag + ' via: @topichog'
      client = Twitter::Client.new(
        :oauth_token => twitter_auth.oauth_token,
        :oauth_token_secret => twitter_auth.oauth_token_secret
      )       
      client.update(tweet_text) if tweet_text.length <= 140       
    end
           
    if linkedin_auth && linkedin_publicise
      client = LinkedIn::Client.new(ENV["LINKEDIN_CONSUMER_KEY"], ENV["LINKEDIN_CONSUMER_SECRET"])
      client.authorize_from_access(linkedin_auth.oauth_token, linkedin_auth.oauth_token_secret) 
      if postable_type == "Topic" && !has_image
        client.add_share({
              comment: "has posted a new topic via TopicHog",
              content: {
              title: postable.title,
              'submitted-url' => post_url,
              'submitted-image-url' => "https://topichogire.s3.amazonaws.com/assets/logo_180.png",
              description: postable.summary
              }
            }) 
     elsif postable_type == "Topic" && has_image
        client.add_share({
              comment: "has posted a new topic via TopicHog",
              content: {
              title: postable.title,
              'submitted-url' => post_url,
              'submitted-image-url' => postable.topicdraftimages.first.image_url(:large).to_s,
              description: postable.summary
              }
            })                   
      elsif postable_type == "Project" && !has_image
        client.add_share({
              comment: "has posted a new project via TopicHog",
              content: {
              title: postable.title,
              'submitted-url' => post_url,
              'submitted-image-url' => "https://topichogire.s3.amazonaws.com/assets/logo_180.png",
              description: postable.summary
              }
            })       
      elsif postable_type == "Project" && has_image
        client.add_share({
              comment: "has posted a new project via TopicHog",
              content: {
              title: postable.title,
              'submitted-url' => post_url,
              'submitted-image-url' => postable.projectdraftimages.first.image_url(:large).to_s,
              description: postable.summary
              }
            })               
      end                                
    end
    
  end
end
