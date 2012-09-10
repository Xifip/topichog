class TpostsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :destroy] 
  before_filter :correct_user, only: :destroy
  
  def create
    @tpost = Tpost.new(params[:topic])
    @post = current_user.posts.build
    @post.postable = @tpost
    if @tpost.save
      if @post.save
        flash[:success] = "Topic created!"
        redirect_to user_path(@post.user)
      else
        @user = @post.user  
        @tpost.destroy 
        render :new 
      end
    else
      @user = current_user   
      render :new 
    end
  end
  
  def new
    @user = User.find_by_id(params[:user_id])
    if current_user != @user
      flash[:error] = "You can't create a topic for another user!"
      redirect_to root_path
    else      
      @tpost = Tpost.new
      @post = @user.posts.build
      @post.postable = @tpost
    end 
  end
  
  def show    
    
  end
  
  def destroy
    @topic.destroy
    redirect_to root_path
  end
  
  private
  
  def correct_user
    #@topic = current_user.topics.find_by_id(params[:id])
    #redirect_to root_path if @topic.nil?
  end
end