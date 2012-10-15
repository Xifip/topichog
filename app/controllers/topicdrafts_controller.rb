class TopicdraftsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user, only: [:create, :destroy, :edit, :show]
  
  def create  
    @topicdraft = current_user.topicdrafts.new(params[:topicdraft])
    @topicdraft.draft_ahead = true
      # note update_attributes Updates this resource with all the attributes 
      # from the passed-in Hash and requests that the record be saved.
    if @topicdraft.save

      flash[:success] = "Topic draft created!"
      redirect_to user_topicdraft_path(current_user, @topicdraft)
    else
      @user = current_user 
      render :new 
    end
  end
  
  def edit
    @user = User.find_by_id(params[:user_id]) 
    @topicdraft = @user.topicdrafts.find_by_id(params[:id])   
  end 

  def update
    @user = User.find_by_id(params[:user_id]) 
    @topicdraft = @user.topicdrafts.find_by_id(params[:id])     
    
    if @topicdraft.update_attributes(title: params[:topicdraft][:title],
                                   summary: params[:topicdraft][:summary],
                                   reference: params[:topicdraft][:reference],
                                   content: params[:topicdraft][:content],
                                   tag_list: params[:topicdraft][:tag_list],
                                   draft_ahead: true
                                   )
           
      flash[:notice] = "Successfully updated topic draft."
      redirect_to user_topicdraft_path(@user, @topicdraft)
    else
      render :action => 'edit'
    end                                   
  end
  
  def show 

    @user = User.find_by_id(params[:user_id]) 
    @topicdraft = @user.topicdrafts.find_by_id(params[:id])   

  end
  
  def new
    @user = User.find_by_id(params[:user_id])
    if current_user != @user
      flash[:error] = "You can't create a topic for another user!"
      redirect_to root_path
    else      
      @topicdraft = Topicdraft.new
    end 
  end
  
  def publish
   @user = User.find_by_id(params[:user_id]) 
   @topicdraft = @user.topicdrafts.find_by_id(params[:id])   
   @topicdraft.update_attributes(draft_ahead: false)
   if @topicdraft.topic == nil
    #create topic and post   
    @topic = Topic.new(title: @topicdraft.title,
                               summary: @topicdraft.summary,
                               content: @topicdraft.content,
                               reference: @topicdraft.reference,
                               tag_list: @topicdraft.tag_list )  
     
    @post = current_user.posts.build    
    if @topic.save     
      @post.postable = @topic
      @topic.topicdraft = @topicdraft
      if @post.save      
        @post.user.tag(@post, :with =>  @topic.tag_list, :on => :tags)
        flash[:success] = "Topic published!"        
        redirect_to user_path(@post.user)
      else
        @user = @post.user  
        @topic.destroy 
        render :new 
      end
    else
      @user = current_user   
      render :edit
    end     
   else
    #update topic and post
    @topic = @topicdraft.topic
    @post = @topic.posts[0]
    if @topic.update_attributes(title: @topicdraft.title,
                                   summary: @topicdraft.summary,
                                   reference: @topicdraft.reference,
                                   content: @topicdraft.content,
                                   tag_list: @topicdraft.tag_list
                                   )
      @post.user.tag(@post, :with =>  @topic.tag_list, :on => :tags)
      flash[:success] = "Topic published!"        
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
