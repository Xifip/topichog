require 'spec_helper'
describe "Authentication" do

  describe "authorization" do
    describe "for other users" do
    
    let(:user) { create_logged_in_user } 
    let(:other_user) { FactoryGirl.create(:user) }
    
     describe "in the Projects controller" do
      let(:post ) { FactoryGirl.create(:post, user: other_user, postable: 
        FactoryGirl.create(:project, title: "Foo", summary: "football"))  }
        describe "submitting to the create action" do
          before { post user_projects_path(other_user) }
          specify { response.should redirect_to(root_path) }
        end
        describe "submitting to the edit action" do
          before { get edit_user_project_path(other_user, post) }
          specify { response.should redirect_to(root_path) }
        end
        describe "submitting to the destroy action" do
          before { delete project_path(post.postable) }
          specify { response.should redirect_to(new_user_session_path) }
        end
     end
     
     describe "in the Topics controller" do
      let(:post ) { FactoryGirl.create(:post, user: other_user, postable: 
        FactoryGirl.create(:topic, title: "Foo", summary: "football"))  }
        describe "submitting to the create action" do
          before { post user_topics_path(other_user) }
          specify { response.should redirect_to(root_path) }
        end
        describe "submitting to the edit action" do
          before { get edit_user_topic_path(other_user, post) }
          specify { response.should redirect_to(root_path) }
        end
        describe "submitting to the destroy action" do
          before { delete topic_path(post.postable) }
          specify { response.should redirect_to(new_user_session_path) }
        end
     end     
    end
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      
      describe "in the Users controller" do
        
        describe "visiting the user show" do
          before { visit user_path(user) }
          it { page.should have_selector('title', text: full_title(user.name)) }
        end
        
        describe "visiting the user index" do
          before { visit users_path }
          it { page.should have_selector('title', text: full_title('All users')) }
        end

        describe "visiting the following page" do
          before { visit following_user_path(user) }          
          it { page.should have_selector('title', text: full_title(user.name + ' | Following')) }
        end
        
        describe "visiting the followers page" do
          before { visit followers_user_path(user) }          
          it { page.should have_selector('title', text: full_title(user.name + ' | Followers')) }
        end
      end   
      
       describe "in the Profiles controller" do
        
        describe "visiting the profile edit" do
          before { get edit_profile_path(user) }
          specify { response.should redirect_to(new_user_session_path) }
        end
        
        describe "submitting to the profile update action" do
          before { put profile_path(user) }
          specify { response.should redirect_to(new_user_session_path) }
        end
      end   
      
      describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { response.should redirect_to(new_user_session_path) }
        end
        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { response.should redirect_to(new_user_session_path) }
        end
      end
      
      describe "in the Likes controller" do
        describe "submitting to the create action" do
          before { post likes_path }
          specify { response.should redirect_to(new_user_session_path) }
        end
        describe "submitting to the destroy action" do
          before { delete like_path(1) }
          specify { response.should redirect_to(new_user_session_path) }
        end
      end
    
      describe "in the Posts controller" do
        describe "submitting to the destroy action" do
          before { delete post_path(FactoryGirl.create(:post, postable: FactoryGirl.create(:ppost))) }
          specify { response.should redirect_to(new_user_session_path) }
        end
        
        describe "submitting to the index action" do
          before { visit posts_path }
          it { page.should have_selector('title', text: full_title('explore topics and projects')) }
        end
      end
      
      describe "in the Topics controller" do
        describe "submitting to the create action" do
          before { post user_topics_path(user) }
          specify { response.should redirect_to(new_user_session_path) }
        end
        describe "submitting to the destroy action" do
          before { delete topic_path(FactoryGirl.create(:topic)) }
          specify { response.should redirect_to(new_user_session_path) }
        end
        describe "submitting to the show action" do
          let (:post) { FactoryGirl.create(:post, user: user, postable:FactoryGirl.create(:topic)) }
          before { visit user_topic_path(user, post) }
          it { page.should have_selector('title', text: full_title(user.name + ' | ' + post.postable.title)) }
        end
      end
      
      describe "in the Projects controller" do
        describe "submitting to the create action" do
          before { post user_projects_path(user) }
          specify { response.should redirect_to(new_user_session_path) }
        end
        describe "submitting to the destroy action" do
          before { delete project_path(FactoryGirl.create(:project)) }
          specify { response.should redirect_to(new_user_session_path) }
        end
          describe "submitting to the show action" do
          let (:post) { FactoryGirl.create(:post, user: user, postable:FactoryGirl.create(:project)) }
          before { visit user_project_path(user, post) }
          it { page.should have_selector('title', text: full_title(user.name + ' | ' + post.postable.title)) }
        end
      end
      
      describe "in the Tposts controller" do
        describe "submitting to the create action" do
          before { post user_tposts_path(user) }
          specify { response.should redirect_to(new_user_session_path) }
        end
        describe "submitting to the destroy action" do
          before { delete tpost_path(FactoryGirl.create(:tpost)) }
          specify { response.should redirect_to(new_user_session_path) }
        end
      end
      
      describe "in the Pposts controller" do
        describe "submitting to the create action" do
          before { post user_pposts_path(user) }
          specify { response.should redirect_to(new_user_session_path) }
        end
        describe "submitting to the destroy action" do
          before { delete ppost_path(FactoryGirl.create(:ppost)) }
          specify { response.should redirect_to(new_user_session_path) }
        end
      end

    end    
  end
end
