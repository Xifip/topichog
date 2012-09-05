class TopicsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :destroy] 

  
  def show
    @topic_user = User.find_by_id(params[:user_id]) 
    @topic = @topic_user.topics.find_by_id(params[:id])
  end
    
  def create
    @topic = current_user.topics.build(params[:topic])
    
    if @topic.save
      flash[:success] = "Topic created!"
      redirect_to root_path
    else      
      render 'static_pages/home'
    end 
  end
  
  def destroy
  end
  
  #def new
  #  @topic = Topic.new
  #end
end