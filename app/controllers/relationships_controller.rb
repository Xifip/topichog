class RelationshipsController < ApplicationController
  before_filter :authenticate_user!
  
  def create    
    @user = User.find(params[:relationship][:followed_id])
    
    if !@user.user_preference
      @user.create_user_preference(mail_on_follower_post: true,
      mail_on_follower: true,
      mail_monthly_update: true,
      mail_new_features: true,
      mail_on_liker: true)
    end
    
    if @user.user_preference.mail_on_follower 
      if !@user.authentication_token
        @user.reset_authentication_token!
      end    
      if @user.authentication_token
        FollowerMailer.follower_confirmation(@user, current_user).deliver
      end
    end  
    current_user.follow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
end
