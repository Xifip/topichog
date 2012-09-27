class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  
  def edit      
    @user = User.find_by_id(params[:id])
    @profile = @user.profile
  end
  
  def update    
    @user = User.find_by_id(params[:id])
    @profile = @user.profile    
    if @profile.update_attributes(bio: params[:profile][:bio], image: params[:profile][:image],
    crop_x: params[:profile][:crop_x], crop_y: params[:profile][:crop_y], 
    crop_w: params[:profile][:crop_w], crop_h: params[:profile][:crop_h])
      if params[:profile][:image].present?
        render :crop
      else  
        #debugger
        if params[:profile][:crop_x].present?
          render :action => 'edit'
        else  
          flash[:notice] = "Successfully updated profile."
          redirect_to user_path(@user)
          #render :action => 'edit'
        end
      end
    else
      render :action => 'edit'
    end    

  end 
end

