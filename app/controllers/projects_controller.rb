class ProjectsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :destroy]
  before_filter :correct_user, only: :destroy
  
  def index
    
  end
  
  def create
    @project = current_user.projects.build(params[:project])
    if @project.save
      flash[:success] = "Project created!"
      redirect_to root_path
    else
      @project_feed_items = []
      render 'static_pages/home'
    end   
  end
  
  def destroy    
    @project.destroy
    redirect_to root_path
  end

  private
  
    def correct_user
      @project = current_user.projects.find_by_id(params[:id])
      redirect_to root_path if @project.nil?
    end
end