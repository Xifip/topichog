class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user
  
  def edit 
    @profile = Profile.find_by_id(params[:id])
    @user = @profile.user
    @avatar = @user.avatar
  end
  
  def update    
    @profile = Profile.find_by_id(params[:id])
    @user = @profile.user
    if @profile.update_attributes(bio: params[:profile][:bio],
    twitter_url: params[:profile][:twitter_url],
    facebook_url: params[:profile][:facebook_url],
    linkedin_url: params[:profile][:linkedin_url],
    mysite_url: params[:profile][:mysite_url],
    myblog_url: params[:profile][:myblog_url])
      flash[:notice] = "Successfully updated profile."
      redirect_to user_path(@user)
    else
      render :action => 'edit'
    end    

  end 
  
  private
  
  def correct_user
    @profile = Profile.find_by_id(params[:id])
    @user = @profile.user
    redirect_to root_path if @user != current_user
  end
end

