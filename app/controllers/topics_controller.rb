class TopicsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :destroy] 
  before_filter :correct_user, only: :destroy
  
  def show
    @topic_user = User.find_by_id(params[:user_id]) 
    @topic = @topic_user.topics.find_by_id(params[:id])
    @user = @topic.user
  end
    
  def create     
    @topic = current_user.topics.build(params[:topic])    
    if @topic.save
      flash[:success] = "Topic created!"
      redirect_to user_path(@topic.user)
    else 
     @user = @topic.user   
     render :new 
    end 
  end
  
  def destroy
    @topic.destroy
    redirect_to root_path
  end
  
  def new

    @user = User.find_by_id(params[:user_id])
    if current_user != @user
      flash[:error] = "You can't create a topic for another user!"
      redirect_to root_path
    else
      @topic = @user.topics.build

    end
 
  end
  
  private
  
    def correct_user
      @topic = current_user.topics.find_by_id(params[:id])
      redirect_to root_path if @topic.nil?
    end
end