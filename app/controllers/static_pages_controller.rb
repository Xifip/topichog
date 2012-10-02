require 'will_paginate/array' 

class StaticPagesController < ApplicationController
  def home
    
    if user_signed_in?
      @project_feed_items = current_user.project_feed.paginate(page: params[:project_page], per_page: 5)
      @topic_feed_items = current_user.topic_feed.paginate(page: params[:topic_page], per_page: 5)
      @feed_items = current_user.feed.paginate(page: params[:feed_page], per_page: 5)
      @liked_posts = current_user.liked_posts.paginate(page: params[:liked_page], per_page: 5)       
    end
  end

  def help
  end
  
   def learn_more
  end
end
