class ProjectdraftimagesController < ApplicationController
  
  def create
    @user = current_user
    @projectdraftimage = @user.projectdraftimages.create(image: params[:projectdraftimage][:image])                                             
  end

  def edit
    @projectdraftimage = Projectdraftimage.find(params[:id])
  end

  def update  
    @projectdraftimage = Projectdraftimage.find(params[:id])
    @projectdraftimage.update_attributes(image: params[:projectdraftimage][:image])
  end

  def destroy
    @projectdraftimage = Projectdraftimage.find(params[:id])
    @projectdraftimage.destroy
    redirect_to projectdraftimages_url, notice: "Image was successfully destroyed."
  end
end
