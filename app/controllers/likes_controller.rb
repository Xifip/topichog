class LikesController < ApplicationController
  before_filter :authenticate_user!
  
  def create  
    @post = Post.find(params[:like][:liked_id])
    @liker_id_selector = '#liker_id_' + current_user.id.to_s
    @liker = current_user
    
    if !@post.user.user_preference
      @post.user.create_user_preference(mail_on_follower_post: true,
      mail_on_follower: true,
      mail_monthly_update: true,
      mail_new_features: true,
      mail_on_liker: true)
    end

    if @post.user.user_preference.mail_on_liker 
      if !@post.user.authentication_token
        @post.user.reset_authentication_token!
      end
      if @post.user.authentication_token
        LikeMailer.like_confirmation(@liker, @post).deliver
      end  
    end          
    
    current_user.like!(@post)
    respond_to do |format|
      format.html {
        if @post.postable_type == "Project"
          redirect_to user_project_path(@post.user, @post.postable)
        end
        if @post.postable_type == "Topic"
          redirect_to user_topic_path(@post.user, @post.postable)
        end
        if @post.postable_type == "Tpost"
          redirect_to user_tpost_path(@post.user, @post.postable)
        end
        if @post.postable_type == "Ppost"
          redirect_to user_ppost_path(@post.user, @post.postable)
        end
      }
      format.js
    end
  end
  
  def destroy  
    @post = Like.find(params[:id]).liked
    @liker_id_selector = '#liker_id_' + current_user.id.to_s
    
    current_user.unlike!(@post)
    
    respond_to do |format|
      format.html {
        if @post.postable_type == "Project"
          redirect_to user_project_path(@post.user, @post.postable)
        end
        if @post.postable_type == "Topic"
          redirect_to user_topic_path(@post.user, @post.postable)
        end
        if @post.postable_type == "Tpost"
          redirect_to user_tpost_path(@post.user, @post.postable)
        end
        if @post.postable_type == "Ppost"
          redirect_to user_ppost_path(@post.user, @post.postable)
        end
      }
      format.js
    end
  end
  
end
