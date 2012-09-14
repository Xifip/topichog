require 'spec_helper'
describe "Authentication" do

  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      
      describe "in the Users controller" do

        describe "visiting the user index" do
          before { visit users_path }
          it { page.should have_selector('h2', text: 'Sign in') }
        end

        describe "visiting the following page" do
          before { visit following_user_path(user) }          
          it { page.should have_selector('h2', text: 'Sign in') }
        end
        
        describe "visiting the followers page" do
          before { visit followers_user_path(user) }          
          it { page.should have_selector('h2', text: 'Sign in') }
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
    
      describe "in the Posts controller" do
        describe "submitting to the destroy action" do
          before { delete post_path(FactoryGirl.create(:post, postable: FactoryGirl.create(:ppost))) }
          specify { response.should redirect_to(new_user_session_path) }
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
