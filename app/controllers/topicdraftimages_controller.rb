class TopicdraftimagesController < ApplicationController
  def index
    #debugger
    @topicdraftimages = Topicdraftimage.all
  end

  def show
    @topicdraftimage = Topicdraftimage.find(params[:id])
  end

  def new
    debugger
    @topicdraftimage = Topicdraftimage.new
  end
=begin
  def create
    #debugger
    @topicdraftimage = Topicdraftimage.new(params[:topicdraftimage])
    if @topicdraftimage.save
      redirect_to topicdraftimages_url, notice: "topicdraftimage was successfully created."
    else
      render :new
    end
  end
=end
  def create
    @topicdraftimage = Topicdraftimage.create(params[:topicdraftimage])
  end

  def edit
    @topicdraftimage = Topicdraftimage.find(params[:id])
  end

  def update
    @topicdraftimage = Topicdraftimage.find(params[:id])
    if @topicdraftimage.update_attributes(params[:image])
      redirect_to topicdraftimages_url, notice: "Image was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @topicdraftimage = Topicdraftimage.find(params[:id])
    @topicdraftimage.destroy
    redirect_to topicdraftimages_url, notice: "Image was successfully destroyed."
  end
end
