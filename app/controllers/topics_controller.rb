class TopicsController < ApplicationController
  

  
  def show
    @topic_user = User.find_by_id(params[:user_id]) 
    @topic = @topic_user.topics.find_by_id(params[:id])
  end  


end