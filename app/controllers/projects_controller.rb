class ProjectsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :destroy]

  def index
    
  end
  
  def create
    @project = current_user.projects.build(params[:project])
    if @project.save
      flash[:success] = "Project created!"
      redirect_to root_path
    else
      render 'static_pages/home'
    end   
  end
  
  def destroy    
  end

end