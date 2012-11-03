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
        
  end

end
