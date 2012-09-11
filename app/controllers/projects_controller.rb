class ProjectsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :destroy]

  def create
    @project = Project.new(params[:project])
    @post = current_user.posts.build    
    if @project.save
      @post.postable = @project
      if @post.save
        flash[:success] = "Project created!"
        redirect_to user_path(@post.user)
      else
        @user = @post.user  
        @project.destroy 
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
      flash[:error] = "You can't create a project for another user!"
      redirect_to root_path
    else      
      @project = Project.new
      @post = @user.posts.build
      @post.postable = @project
    end 
  end
  
  def show    
    @project_user = User.find_by_id(params[:user_id]) 
    @post = @project_user.posts.find_by_id(params[:id])
    @project = @post.postable
    @user = @post.user
  end
  
  def destroy

  end 

end