class PostsController < ApplicationController
  before_filter :authenticate_user!, only: [:destroy] 
  before_filter :correct_user, only: :destroy
  
  def destroy
    @post.destroy
    redirect_to root_path
  end
  
  private
  
  def correct_user
    @post = current_user.posts.find_by_id(params[:id])
    redirect_to root_path if @post.nil?
  end
end