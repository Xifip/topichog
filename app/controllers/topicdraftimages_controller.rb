class TopicdraftimagesController < ApplicationController

  def create
    @user = current_user
    @topicdraftimage = @user.topicdraftimages.create(image: params[:topicdraftimage][:image])                                            
  end

  def edit
    @topicdraftimage = Topicdraftimage.find(params[:id])
  end

  def update  
    @topicdraftimage = Topicdraftimage.find(params[:id])
    @topicdraftimage.update_attributes(image: params[:topicdraftimage][:image])
  end

  def destroy
    @topicdraftimage = Topicdraftimage.find(params[:id])
    @topicdraftimage.destroy
    redirect_to topicdraftimages_url, notice: "Image was successfully destroyed."
  end
end
