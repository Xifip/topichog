require 'will_paginate/array' 

class StaticPagesController < ApplicationController
  def home
    tag_cloud

    if user_signed_in?
      @project_feed_items = current_user.project_feed.page(params[:project_page]).per_page(5)
      @topic_feed_items = current_user.topic_feed.page(params[:topic_page]).per_page(5)
      @feed_items = current_user.feed.page(params[:feed_page]).per_page(5)
      @liked_posts = current_user.liked_posts.page(params[:liked_page]).per_page(5)       
    end
  end

  def help
  end
  
   def learn_more
  end
  
  def tag_cloud
    @tags = Post.tag_counts_on(:tags)
    @tags.sort! { |a,b| b.count <=> a.count }
    @tags = @tags[0..40]

  end 
end
