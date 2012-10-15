class TopicsController < ApplicationController
  
  def show   
    #debugger
    @topic_user = User.find_by_id(params[:user_id]) 
    @post = @topic_user.posts.find_by_postable_id(params[:id])
    @topic = @post.postable   
    @user = @post.user
    @likers = @post.likers#.paginate(page: params[:page])
    @likes_count =  @post.likes_count
    @tags_item = @post.owner_tags_on(@user, :tags)
  end

end
