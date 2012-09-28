class LikesController < ApplicationController
  before_filter :authenticate_user!
  
  def create  
    @post = Post.find(params[:like][:liked_id])
    @liker_id_selector = '#liker_id_' + current_user.id.to_s
    @liker = current_user
    LikeMailer.like_confirmation(@liker, @post).deliver
    current_user.like!(@post)
    #debugger
    respond_to do |format|
      format.html {
        if @post.postable_type == "Project"
          redirect_to user_project_path(@post.user, @post.postable)
        end
        if @post.postable_type == "Topic"
          redirect_to user_topic_path(@post.user, @post.postable)
        end
        if @post.postable_type == "Tpost"
          redirect_to user_tpost_path(@post.user, @post.postable)
        end
        if @post.postable_type == "Ppost"
          redirect_to user_ppost_path(@post.user, @post.postable)
        end
      }
      format.js
    end
  end
  
  def destroy
    @post = Like.find(params[:id]).liked
    @liker_id_selector = '#liker_id_' + current_user.id.to_s
    
    current_user.unlike!(@post)
    
    respond_to do |format|
      format.html {
        if @post.postable_type == "Project"
          redirect_to user_project_path(@post.user, @post.postable)
        end
        if @post.postable_type == "Topic"
          redirect_to user_topic_path(@post.user, @post.postable)
        end
        if @post.postable_type == "Tpost"
          redirect_to user_tpost_path(@post.user, @post.postable)
        end
        if @post.postable_type == "Ppost"
          redirect_to user_ppost_path(@post.user, @post.postable)
        end
      }
      format.js
    end
  end
  
end
