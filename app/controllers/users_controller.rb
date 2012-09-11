require 'will_paginate/array' 

class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @pposts = @user.posts.find_all_by_postable_type("Ppost").paginate(page: params[:page], per_page: 5)
    @tposts = @user.posts.find_all_by_postable_type("Tpost").paginate(page: params[:page], per_page: 5) 
    @projects = @user.posts.find_all_by_postable_type("Project").paginate(page: params[:page], per_page: 5)
    @topics = @user.posts.find_all_by_postable_type("Topic").paginate(page: params[:page], per_page: 5)    
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  

end