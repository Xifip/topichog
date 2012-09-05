class TopicsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :destroy] 

  
  def show
    @topic_user = User.find_by_id(params[:user_id]) 
    @topic = @topic_user.topics.find_by_id(params[:id])
  end
    
  def create
  end
  
  def destroy
  end
  
  def new
    
  end
end