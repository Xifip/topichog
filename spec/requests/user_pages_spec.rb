require 'spec_helper'
require "debugger"


describe "User pages" do

  describe "profile page" do
    #let(:user) { FactoryGirl.create(:user) }
    let(:user) { create_logged_in_user } 
    let!(:m1) { FactoryGirl.create(:project, user: user, title: "Foo", summary: "football") }
    let!(:m2) { FactoryGirl.create(:project, user: user, title: "Bar", summary: "barley") }    
    
    
    describe "should have a current_user" do
      before {visit user_path(user)}
      it { page.should have_selector('h1', text: user.name) }
      it { page.should have_content(m1.title) }
      it { page.should have_content(m2.title) }
      it { page.should have_content(user.projects.count) }
    end
    
    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user, name: "foo_other", email: "other@foo.com", password: "other_foo", password_confirmation: "other_foo") }
      
      describe "following a user" do
        before { visit user_path(other_user) }
        
        
        it "should increment the followed user count" do
          page.should have_selector('input', value: 'Follow')
          #debugger
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end
        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end
        describe "toggling the button" do
          before { click_button "Follow" }
          it { page.should have_selector('input', value: 'Unfollow') }
        end
      end
      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end
        it "should decrement the followed user count" do
          expect do
          click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end
        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end
        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { page.should have_selector('input', value: 'Follow') }
        end
      end
    end
  end
  
  describe "project pages" do
    
    #let(:user) { FactoryGirl.create(:user) }
    #before { @project = user.projects.build(title: "Lorem ipsum", summary: "My rails project") }   
    
    describe "users project page" do
      let(:user) { create_logged_in_user } 
      let(:other_user) { FactoryGirl.create(:user, name: "foo_other", email: "other@foo.com", password: "other_foo", password_confirmation: "other_foo") }
      let!(:m1) { FactoryGirl.create(:project, user: other_user, title: "Foo", summary: "football") }
      
      before do        
        visit user_project_path(other_user, m1)
      end
      
      subject{page}
      
      it { should have_selector('h3', text: 'Project details page') }
      it { should have_selector('h1', text: m1.title) }
      it { should have_selector('p', text: m1.summary) }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end    
  end

end