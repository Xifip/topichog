class ProjectsController < ApplicationController
 
  def show 
    @project_user = User.find_by_id(params[:user_id]) 
    @post = @project_user.posts.project_with_postable_id(params[:id])
    @project = @post.postable
    @user = @post.user
    @likers = @post.likers#.paginate(page: params[:page])
    @likes_count =  @post.likes_count
    @tags_item = @post.owner_tags_on(@user, :tags)
    @projectdraftimage = Projectdraftimage.projectdraftimage_for_project(@project).first 
    @twitter_auth = @user.authentications.find_by_provider('twitter')
    @facebook_auth = @user.authentications.find_by_provider('facebook')
    @linkedin_auth = @user.authentications.find_by_provider('linkedin') 
    @tag0 = @project.tag_list[0]
    @tag1 = @project.tag_list[1]   
   end

end
