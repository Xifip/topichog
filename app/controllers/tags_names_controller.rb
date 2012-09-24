class TagsNamesController < ApplicationController
  def index
    @tags_names = Post.tag_counts_on(:tags).order(:name).where("name like ?", "%#{params[:term]}%")
    render json: @tags_names.map(&:name)
  end
end
