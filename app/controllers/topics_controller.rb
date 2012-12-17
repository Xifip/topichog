class TopicsController < ApplicationController
  
  def show  
    @topic_user = User.find_by_id(params[:user_id]) 
    @post = @topic_user.posts.topic_with_postable_id(params[:id])
    @topic = @post.postable   
    @user = @post.user
    @likers = @post.likers#.paginate(page: params[:page])
    @likes_count =  @post.likes_count
    @tags_item = @post.owner_tags_on(@user, :tags)
    @topicdraftimage = Topicdraftimage.topicdraftimage_for_topic(@topic).first
    @twitter_auth = @user.authentications.find_by_provider('twitter')
    @facebook_auth = @user.authentications.find_by_provider('facebook')
    @linkedin_auth = @user.authentications.find_by_provider('linkedin') 
    @tag0 = @topic.tag_list[0]
    @tag1 = @topic.tag_list[1]    
  end
  
  def publicise
      @topic = Topic.find_by_id(params[:id])
      @user = @topic.posts[0].user
      linkedin_publicise = params[:linkedin_pub] == '1' ? true : false 
      facebook_publicise = params[:facebook_pub] == '1' ? true : false 
      twitter_publicise = params[:twitter_pub] == '1' ? true : false 
     if !linkedin_publicise && !facebook_publicise && !twitter_publicise
      flash[:failure] = "You need to select the networks that you want to post to!"
     else
       PublishWorker.perform_async(current_user.id, user_topic_url(@user, @topic), @topic.id, "Topic", linkedin_publicise, facebook_publicise, twitter_publicise) 
       flash[:success] = "Topic posted to your networks!"
     end  
     redirect_to user_topic_path(@user, @topic)
  end
end
