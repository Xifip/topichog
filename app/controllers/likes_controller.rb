class LikesController < ApplicationController
  before_filter :authenticate_user!
  
  def create  
    @post = Post.find(params[:like][:liked_id])
    current_user.like!(@post)
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
    #respond_to do |format|
    #  format.html { redirect_to @post }
    #  format.js
    #end
  end
  
  def destroy
    @post = Like.find(params[:id]).liked
    current_user.unlike!(@post)
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
    #respond_to do |format|
    #  format.html { redirect_to @post }
    #  format.js
    #end
  end
  
end
