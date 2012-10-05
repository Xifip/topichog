class TopicsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :destroy] 
  before_filter :correct_user, only: [:create, :destroy, :edit]
  
  def create  
    @topic = Topic.new(params[:topic])
    @post = current_user.posts.build    
    if @topic.save
      @post.postable = @topic
      if @post.save
        @post.user.tag(@post, :with =>  params[:topic][:tag_list], :on => :tags)
        flash[:success] = "Topic created!"        
        redirect_to user_path(@post.user)
      else
        @user = @post.user  
        @topic.destroy 
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
      flash[:error] = "You can't create a topic for another user!"
      redirect_to root_path
    else      
      @topic = Topic.new
      @post = @user.posts.build
      @post.postable = @topic
    end 
  end
  
  def show   
    @topic_user = User.find_by_id(params[:user_id]) 
    @post = @topic_user.posts.find_by_id(params[:id])
    @topic = @post.postable
    @user = @post.user
    @likers = @post.likers#.paginate(page: params[:page])
    @likes_count =  @post.likes_count
    @tags_item = @post.owner_tags_on(@user, :tags)
    #@tag_names = []
    #@tags.each do |tag|
      #@tag_names.push tag.name
    #end

  end
  
  def edit
    @topic_user = User.find_by_id(params[:user_id]) 
    @post = @topic_user.posts.find_by_id(params[:id])
    @topic = @post.postable
    @user = @post.user  
  end 
  
  def update
    @topic_user = User.find_by_id(params[:user_id]) 
    @post = @topic_user.posts.find_by_id(params[:id])
    @topic = @post.postable
    @user = @post.user 
    if @topic.update_attributes(title: params[:topic][:title],
                                   summary: params[:topic][:summary],
                                   reference: params[:topic][:reference],
                                   content: params[:topic][:content],
                                   tag_list: params[:topic][:tag_list],
                                   )
      @post.postable = @topic 
      flash[:notice] = "Successfully updated topic."
      redirect_to user_topic_path(@user, @post)
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
