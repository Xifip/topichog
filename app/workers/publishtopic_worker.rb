class PublishtopicWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform(user_id, post_url, topic_id)
    user = User.find(user_id)
    topic = Topic.find(topic_id)

    if user.provider == "facebook"
      user.facebook.put_connections("me", "topichog:post", article: post_url)
    elsif user.provider == "twitter"      
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
        :oauth_token => user.oauth_token,
        :oauth_token_secret => user.oauth_secret
      )       
      client.update(tweet_text) if tweet_text.length <= 140        
    
    elsif user.provider == "linkedin"    
      client = LinkedIn::Client.new(ENV["LINKEDIN_CONSUMER_KEY"], ENV["LINKEDIN_CONSUMER_SECRET"])
      client.authorize_from_access(user.oauth_token, user.oauth_secret) 
      client.add_share({
            comment: "has posted a new topic via TopicHog",
            content: {
            title: topic.title,
            'submitted-url' => post_url,
            'submitted-image-url' => topic.topicdraftimages.first.image_url(:large).to_s,
            description: topic.summary
            }
          }) 
      client.add_share({
          comment: 'Testcomment',
          content: {
          title: 'Thsi is a test title',
          'submitted-url' => 'http://www.example.com',
          'submitted-image-url' => 'https://topichogire.s3.amazonaws.com/uploads/topicdraftimage/image/215/large_049860-black-paint-splatter-icon-natural-wonders-cactus-sc48.png',
          description: 'This is a test description....'
          }
        })                     
    end
  end
end
