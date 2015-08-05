class AvatarsController < ApplicationController
    before_filter :authenticate_user!
  before_filter :correct_user

  def edit
    @avatar = Avatar.find_by_id(params[:id])
    @user = @avatar.user
   #@uploader = @avatar.image
    #@uploader.success_action_redirect = new_painting_url
  end

  def update
    @avatar = Avatar.find_by_id(params[:id])
    #@uploader = @avatar.image
    @user = @avatar.user
    if @avatar.update_attributes(params[:avatar])
#    if @avatar.update_attributes(image: params[:avatar][:image],
#    crop_x: params[:avatar][:crop_x], crop_y: params[:avatar][:crop_y],
#    crop_w: params[:avatar][:crop_w], crop_h: params[:avatar][:crop_h])
      if params[:avatar][:image].present?
          render :crop
      else
        flash[:notice] = "Successfully updated avatar."
        redirect_to edit_profile_path(@user)
      end
    else
      redirect_to edit_profile_path(@user)
    end
  end

  def correct_user
    @avatar = Avatar.find_by_id(params[:id])
    @user = @avatar.user
    redirect_to root_path if @user != current_user
  end
end
