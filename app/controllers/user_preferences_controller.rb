class UserPreferencesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user
  
  def create
  end
  
  def edit
    @user = User.find_by_id(params[:id])
    if !@user.user_preference
      @user.create_user_preference(mail_on_follower_post: true,
      mail_on_follower: true,
      mail_monthly_update: true,
      mail_new_features: true,
      mail_on_liker: true)    
    end
    @user_preference = @user.user_preference
  end
  
  def update
    @user = User.find_by_id(params[:id])
    @user.user_preference.update_attributes(params[:user_preference])
    redirect_to user_path(@user)
  end

  private
  
  def correct_user
    @user = User.find_by_id(params[:id])
    redirect_to root_path if @user != current_user
  end
end  
