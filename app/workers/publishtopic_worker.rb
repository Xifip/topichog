class PublishtopicWorker
  include Sidekiq::Worker
  sidekiq_options retry: true
  
  def perform(user_id, post_url, topic_id, linkedin_publicise, facebook_publicise, twitter_publicise)
    user = User.find(user_id)
    topic = Topic.find(topic_id)
    
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
      char_count = (topic.title + ': ' + post_url+ ' via: @topichog').length
      tag0 = ' #' + topic.tag_list[0].gsub(/\s+/, "")
      tag1 = ' #' + topic.tag_list[1].gsub(/\s+/, "")    
      
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
            
      tweet_text = topic.title + ': ' + post_url + shorter_tag + longer_tag + ' via: @topichog'
      client = Twitter::Client.new(
        :oauth_token => twitter_auth.oauth_token,
        :oauth_token_secret => twitter_auth.oauth_token_secret
      )       
      client.update(tweet_text) if tweet_text.length <= 140        
    end
           
    if linkedin_auth && linkedin_publicise
      client = LinkedIn::Client.new(ENV["LINKEDIN_CONSUMER_KEY"], ENV["LINKEDIN_CONSUMER_SECRET"])
      client.authorize_from_access(linkedin_auth.oauth_token, linkedin_auth.oauth_token_secret) 
      client.add_share({
            comment: "has posted a new topic via TopicHog",
            content: {
            title: topic.title,
            'submitted-url' => post_url,
            'submitted-image-url' => topic.topicdraftimages.first.image_url(:large).to_s,
            description: topic.summary
            }
          })                     
    end
    
  end
end
