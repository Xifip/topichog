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

  def publicise
      @project = Project.find_by_id(params[:id])
      @user = @project.posts[0].user
      linkedin_publicise = params[:linkedin_pub] == '1' ? true : false 
      facebook_publicise = params[:facebook_pub] == '1' ? true : false 
      twitter_publicise = params[:twitter_pub] == '1' ? true : false 
     if !linkedin_publicise && !facebook_publicise && !twitter_publicise
      flash[:failure] = "You need to select the networks that you want to post to!"
     else
       PublishWorker.perform_async(current_user.id, user_project_url(@user, @project), @project.id, "Project", linkedin_publicise, facebook_publicise, twitter_publicise) 
       flash[:success] = "Project posted to your networks!"
     end  
     redirect_to user_project_path(@user, @project)
  end
end
