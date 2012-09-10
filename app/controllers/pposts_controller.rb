class PpostsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :destroy] 
  before_filter :correct_user, only: :destroy
  
  def create
    
  end
  
  def show    
    
  end
  
  def destroy
    
  end
  
  private
  
  def correct_user
    #@topic = current_user.topics.find_by_id(params[:id])
    #redirect_to root_path if @topic.nil?
  end
end