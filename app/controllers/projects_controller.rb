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

   end

end
