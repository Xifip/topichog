class ProjectsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :destroy]
  before_filter :correct_user, only: [:create, :destroy, :edit]

  def create
    @project = Project.new(params[:project])
    @post = current_user.posts.build    
    if @project.save
      @post.postable = @project
      if @post.save
        @post.user.tag(@post, :with =>  params[:project][:tag_list], :on => :tags)
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
    @likers = @post.likers#.paginate(page: params[:page])
    @likes_count =  @post.likes_count
    @tags_item = @post.owner_tags_on(@user, :tags)
   end
   
  def edit
    @project_user = User.find_by_id(params[:user_id]) 
    @post = @project_user.posts.find_by_id(params[:id])
    @project = @post.postable
    @user = @post.user  
    #debugger
    #p = 5  
  end 
  
  def update
    @project_user = User.find_by_id(params[:user_id]) 
    @post = @project_user.posts.find_by_id(params[:id])
    @project = @post.postable
    @user = @post.user 
    if @project.update_attributes(title: params[:project][:title],
                                   summary: params[:project][:summary],
                                   reference: params[:project][:reference],
                                   content: params[:project][:content],
                                   tag_list: params[:project][:tag_list],
                                   )
      @post.postable = @project 
      flash[:notice] = "Successfully updated project."
      redirect_to user_project_path(@user, @post)
    else
      render :action => 'edit'
    end                                   
  end
  
  def destroy

  end 

  private
  
  def correct_user
    @user = User.find_by_id(params[:user_id])
    redirect_to root_path if @user != current_user
  end
end
