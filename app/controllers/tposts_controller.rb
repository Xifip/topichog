class TpostsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :destroy] 
  
  def create
    @tpost = Tpost.new(params[:tpost])
    @post = current_user.posts.build    
    if @tpost.save
      @post.postable = @tpost
      if @post.save
        flash[:success] = "Topic created!"
        redirect_to user_path(@post.user)
      else
        @user = @post.user  
        @tpost.destroy 
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
      @tpost = Tpost.new
      @post = @user.posts.build
      @post.postable = @tpost
    end 
  end
  
  def show    
    @topic_user = User.find_by_id(params[:user_id]) 
    @post = @topic_user.posts.find_by_id(params[:id])
    @tpost = @post.postable
    @user = @post.user
    @likers = @post.likers.paginate(page: params[:page])
    @likes_count =  @post.likes_count
  end
  
  def destroy

  end  

end
