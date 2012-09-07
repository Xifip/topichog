class StaticPagesController < ApplicationController
  def home
    
    if user_signed_in?
      @project = current_user.projects.build 
      @project_feed_items = current_user.project_feed.paginate(page: params[:page])
      @topic_feed_items = current_user.topic_feed.paginate(page: params[:page])
      @feed_items = current_user.feed#.paginate(page: params[:page])
    end
  end

  def help
  end
end
