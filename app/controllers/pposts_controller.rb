class PpostsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :destroy]   
  
  def create
    @ppost = Ppost.new(params[:ppost])
    @post = current_user.posts.build    
    if @ppost.save
      @post.postable = @ppost
      if @post.save
        flash[:success] = "Project created!"
        redirect_to user_path(@post.user)
      else
        @user = @post.user  
        @ppost.destroy 
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
      @ppost = Ppost.new
      @post = @user.posts.build
      @post.postable = @ppost
    end 
  end
  
  def show    
    @project_user = User.find_by_id(params[:user_id]) 
    @post = @project_user.posts.find_by_id(params[:id])
    @ppost = @post.postable
    @user = @post.user
    @likers = @post.likers.paginate(page: params[:page])
    @likes_count =  @post.likes_count
  end
  
  def destroy
    
  end
  
end
