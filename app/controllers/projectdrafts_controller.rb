class ProjectdraftsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user, only: [:create, :destroy, :edit, :show]
  
  def create  
    @projectdraftimage = Projectdraftimage.find_by_id(params[:projectdraft][:image_id])  
    @projectdraft = current_user.projectdrafts.new(title: params[:projectdraft][:title],
                                             summary: params[:projectdraft][:summary],
                                             reference: params[:projectdraft][:reference],
                                             content: params[:projectdraft][:content],
                                             tag_list: params[:projectdraft][:tag_list])                                             
    @projectdraft.draft_ahead = true
      # note update_attributes Updates this resource with all the attributes 
      # from the passed-in Hash and requests that the record be saved.
    if @projectdraft.save
      if @projectdraftimage    
        @projectdraftimage.projectdraft_id = @projectdraft.id
        @projectdraftimage.save
      end  
      flash[:success] = "Project draft created!"
      redirect_to user_projectdraft_path(current_user, @projectdraft)
    else
      @user = current_user 
      render :new 
    end
  end
  
  def edit
    @user = User.find_by_id(params[:user_id]) 
    @projectdraft = @user.projectdrafts.find_by_id(params[:id])
    @projectdraftimage = Projectdraftimage.projectdraftimage_for_projectdraft(@projectdraft).first
  end 

  def update
    @user = User.find_by_id(params[:user_id]) 
    @projectdraftimage = Projectdraftimage.find_by_id(params[:projectdraft][:image_id])       
    @projectdraft = @user.projectdrafts.find_by_id(params[:id])    
    
    if @projectdraftimage
      if @projectdraftimage.projectdraft_id != @projectdraft.id
        @projectdraftimage.projectdraft_id = @projectdraft.id
        @projectdraftimage.save
      end  
    end    
    
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
    @projectdraft = @user.projectdrafts.find_by_id(params[:id])
    @projectdraftimage = Projectdraftimage.projectdraftimage_for_projectdraft(@projectdraft).first 
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
  
  def discard
    @user = User.find_by_id(params[:user_id]) 
    @projectdraft = @user.projectdrafts.find_by_id(params[:id])
    @projectdraftimage = Projectdraftimage.projectdraftimage_for_projectdraft(@projectdraft).first
    if @projectdraftimage
      @projectdraftimage.destroy
    end  
    if @projectdraft.project
      if @projectdraft.update_attributes(title:@projectdraft.project.title,
                                     summary: @projectdraft.project.summary,
                                     reference: @projectdraft.project.reference,
                                     content: @projectdraft.project.content,
                                     tag_list: @projectdraft.project.tag_list,
                                     draft_ahead: false
                                     )          
        flash[:notice] = "Successfully discarded draft project."
        redirect_to user_path(@user)
      else
        render :action => 'show'
      end  
    else
      @projectdraft.destroy
      flash[:notice] = "Successfully discarded draft project."
      redirect_to user_path(@user)
    end
  end
  
  def publish
   @user = User.find_by_id(params[:user_id]) 
   @projectdraft = @user.projectdrafts.find_by_id(params[:id])
   @projectdraft.update_attributes(draft_ahead: false)   
   @projectdraftimage = Projectdraftimage.projectdraftimage_for_projectdraft(@projectdraft).first 
    
   if @projectdraft.project == nil
    #create project and post and image
    @project = Project.new(title: @projectdraft.title,
                               summary: @projectdraft.summary,
                               content: @projectdraft.content,
                               reference: @projectdraft.reference,
                               tag_list: @projectdraft.tag_list)
     
    @post = current_user.posts.build    
    if @project.save    
      if @projectdraftimage
        @projectimage = @user.projectdraftimages.create(image: @projectdraftimage.image)        
        if @projectimage.project_id != @project.id
          @projectimage.project_id = @project.id
          @projectimage.save
        end  
      end      
      
      @post.postable = @project
      @project.projectdraft = @projectdraft
      if @post.save      
        @post.user.tag(@post, :with =>  @project.tag_list, :on => :tags)          
        #User.delay.share_project_FB(current_user.id, user_project_url(@project)) 
        #debugger
        PublishWorker.perform_async(current_user.id, user_project_url(@user, @project))
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
    #update project and post and image
    @project = @projectdraft.project
    @post = @project.posts[0]
    if @project.update_attributes(title: @projectdraft.title,
                                   summary: @projectdraft.summary,
                                   reference: @projectdraft.reference,
                                   content: @projectdraft.content,
                                   tag_list: @projectdraft.tag_list)

      @projectoldimage = Projectdraftimage.projectdraftimage_for_project(@project).first 
      
      
      if @projectdraftimage
        @projectimage = @user.projectdraftimages.create(image: @projectdraftimage.image)   
        if @projectimage.project_id != @project.id
          @projectimage.project_id = @project.id
          if @projectimage.save && @projectoldimage
            @projectoldimage.destroy
          end
        end  
      end 
                                   
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
