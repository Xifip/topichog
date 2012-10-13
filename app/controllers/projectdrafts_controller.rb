class ProjectdraftsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user, only: [:create, :destroy, :edit, :show]
  
  def create  
    @projectdraft = current_user.projectdrafts.new(params[:projectdraft])
    @projectdraft.draft_ahead = true
      # note update_attributes Updates this resource with all the attributes 
      # from the passed-in Hash and requests that the record be saved.
    if @projectdraft.save

      flash[:success] = "Project draft created!"
      redirect_to user_projectdraft_path(current_user, @projectdraft)
    else
      @user = current_user 
      render :new 
    end
  end
  
  def edit
    @user = User.find_by_id(params[:user_id]) 
    @projectdraft = Projectdraft.find_by_id(params[:id])
    #@topic = @post.postable
    #@user = @post.user  
  end 

  def update
    @user = User.find_by_id(params[:user_id]) 
    @projectdraft = Projectdraft.find_by_id(params[:id])    
    
    if @projectdraft.update_attributes(title: params[:projectdraft][:title],
                                   summary: params[:projectdraft][:summary],
                                   reference: params[:projectdraft][:reference],
                                   content: params[:projectdraft][:content],
                                   tag_list: params[:projectdraft][:tag_list],
                                   draft_ahead: true
                                   )
           
      flash[:notice] = "Successfully updated project draft."
      redirect_to user_projectdraft_path(@user, @projectdraft)
    else
      render :action => 'edit'
    end                                   
  end
  
  def show 

    @user = User.find_by_id(params[:user_id]) 
    @projectdraft = Projectdraft.find_by_id(params[:id])

  end
  
  def new
    @user = User.find_by_id(params[:user_id])
    if current_user != @user
      flash[:error] = "You can't create a project for another user!"
      redirect_to root_path
    else      
      @projectdraft = Projectdraft.new
    end 
  end
  
  def publish
   #debugger
   @user = User.find_by_id(params[:user_id]) 
   @projectdraft = Projectdraft.find_by_id(params[:id])
   @projectdraft.update_attributes(draft_ahead: false)
   if @projectdraft.project == nil
    #create project and post   
    @project = Project.new(title: @projectdraft.title,
                               summary: @projectdraft.summary,
                               content: @projectdraft.content,
                               reference: @projectdraft.reference,
                               tag_list: @projectdraft.tag_list )  
     
    @post = current_user.posts.build    
    if @project.save     
      @post.postable = @project
      @project.projectdraft = @projectdraft
      if @post.save      
        @post.user.tag(@post, :with =>  @project.tag_list, :on => :tags)
        flash[:success] = "Project published!"        
        redirect_to user_path(@post.user)
      else
        @user = @post.user  
        @project.destroy 
        render :new 
      end
    else
      @user = current_user   
      render :edit
    end     
   else
    #update project and post
    @project = @projectdraft.project
    @post = @project.posts[0]
    if @project.update_attributes(title: @projectdraft.title,
                                   summary: @projectdraft.summary,
                                   reference: @projectdraft.reference,
                                   content: @projectdraft.content,
                                   tag_list: @projectdraft.tag_list
                                   )
      @post.user.tag(@post, :with =>  @project.tag_list, :on => :tags)
      flash[:success] = "Project published!"        
      redirect_to user_path(@user)                                   
    else
      @user = current_user   
      render :edit
    end                               
   end
  end
  
  private
  
 def correct_user
    @user = User.find_by_id(params[:user_id])
    redirect_to root_path if @user != current_user
  end
end  
