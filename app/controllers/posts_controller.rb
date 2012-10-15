class PostsController < ApplicationController
  before_filter :authenticate_user!, only: [:destroy] 
  before_filter :correct_user, only: :destroy
  
  def index  

    tag_cloud
    @tag_filter =  [params[:tag1]||'',params[:tag2]||'',params[:tag3]||'',
                                           params[:tag4]||'',params[:tag5]||'']
    @tag_filter.sort! do |x, y| 
      if x == '' 
       1
      elsif y == '' 
       -1
      else      
        x <=> y
      end
    end
    if @tag_filter[0] == ''
       @feed_items = Post.scoped.paginate(page: params[:feed_page], 
                                                              per_page: 10)
    elsif @tag_filter[0] != ''
      @feed_items = Post.tagged_with(@tag_filter.join(", "))
      @feed_items = Post.tagged_with(@tag_filter.join(", ")).paginate(page: 
                                          params[:feed_page], per_page: 10) 
    end  
  end
  
  def destroy
    
    if @post.postable_type == "Ppost"
      ppost = Ppost.find_by_id(@post.postable_id)
      ppost.destroy
    end
    if @post.postable_type == "Tpost"
      tpost = Tpost.find_by_id(@post.postable_id)
      tpost.destroy
    end
     if @post.postable_type == "Project"
      project = Project.find_by_id(@post.postable_id)
      project.destroy
    end
    if @post.postable_type == "Topic"
      topic = Topic.find_by_id(@post.postable_id)
      topic.destroy
    end
    redirect_to root_path
  end
  
  def tag_cloud
    @tags = Post.tag_counts_on(:tags)
    @tags.sort! { |a,b| b.count <=> a.count }
    @tags = @tags[0..20]

  end
  
  private
  
  def correct_user
    @post = current_user.posts.find_by_id(params[:id])
    redirect_to root_path if @post.nil?
  end
end
