class PostsController < ApplicationController
  before_filter :authenticate_user!, only: [:destroy] 
  before_filter :correct_user, only: :destroy
  
  def destroy
    
    if @post.postable_type == "Ppost"
      ppost = Ppost.find_by_id(@post.postable_id)
      ppost.destroy
    end
    if @post.postable_type == "Tpost"
      tpost = Tpost.find_by_id(@post.postable_id)
      tpost.destroy
    end
     if @post.postable_type == "Project"
      project = Project.find_by_id(@post.postable_id)
      project.destroy
    end
    if @post.postable_type == "Topic"
      topic = Topic.find_by_id(@post.postable_id)
      topic.destroy
    end
    redirect_to root_path
  end
  
  private
  
  def correct_user
    @post = current_user.posts.find_by_id(params[:id])
    redirect_to root_path if @post.nil?
  end
end