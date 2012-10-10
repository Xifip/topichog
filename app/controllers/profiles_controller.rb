class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user
  
  def edit 
    @profile = Profile.find_by_id(params[:id])
    @user = @profile.user
    @avatar = @user.avatar
    debugger
    @uploader = @avatar.image
  end
  
  def update
 
    @profile = Profile.find_by_id(params[:id])
    @user = @profile.user
   
     respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @profile.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  
  end
 
  private
  
  def correct_user
    @profile = Profile.find_by_id(params[:id])
    @user = @profile.user
    redirect_to root_path if @user != current_user
  end
end

