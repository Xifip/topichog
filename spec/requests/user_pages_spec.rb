require 'spec_helper'
require "debugger"


describe "User pages" do
  describe "profile page with posts" do 
    
    let(:user) { create_logged_in_user } 
    let!(:p1) { FactoryGirl.create(:ppost, title: "Foo", summary: "football") }
    let!(:post1) { FactoryGirl.create(:post, user: user, postable: p1) }
    
    let!(:p2) { FactoryGirl.create(:ppost, title: "Bar", summary: "barley") }
    let!(:post2) { FactoryGirl.create(:post, user: user, postable: p2) }
    
    let!(:t1) { FactoryGirl.create(:tpost, title: "topic1", summary: "football") }
    let!(:post3) { FactoryGirl.create(:post, user: user, postable: t1) }
    
    let!(:t2) { FactoryGirl.create(:tpost, title: "topic2", summary: "barley") }
    let!(:post4) { FactoryGirl.create(:post, user: user, postable: t2) }

    describe "should have a current_user" do
      before {visit user_path(user)}
      it { page.should have_selector('h1', text: user.name) }
      it { page.should have_content(p1.title) }
      it { page.should have_content(p2.title) }
      it { page.should have_content(user.posts.find_all_by_postable_type("Ppost").count) }
      it { page.should have_content(t1.title) }
      it { page.should have_content(t2.title) }
      it { page.should have_content(user.posts.find_all_by_postable_type("Ppost").count) }
    end
  end
  
  describe "profile page" do

    let(:user) { create_logged_in_user } 
    let!(:p1) { FactoryGirl.create(:project, user: user, title: "Foo", summary: "football") }
    let!(:p2) { FactoryGirl.create(:project, user: user, title: "Bar", summary: "barley") }    
    let!(:t1) { FactoryGirl.create(:project, user: user, title: "topic1", summary: "football") }
    let!(:t2) { FactoryGirl.create(:project, user: user, title: "topic2", summary: "barley") }   
    
    describe "should have a current_user" do
      before {visit user_path(user)}
      it { page.should have_selector('h1', text: user.name) }
      it { page.should have_content(p1.title) }
      it { page.should have_content(p2.title) }
      it { page.should have_content(user.projects.count) }
      it { page.should have_content(t1.title) }
      it { page.should have_content(t2.title) }
      it { page.should have_content(user.topics.count) }
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
      let!(:p1) { FactoryGirl.create(:project, user: other_user, title: "Foo", summary: "football") }
      
      before do        
        visit user_project_path(other_user, p1)
      end
      
      subject{page}
      
      it { should have_selector('h3', text: 'Project details page') }
      it { should have_selector('h1', text: p1.title) }
      it { should have_selector('p', text: p1.summary) }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end    
  end
  
  describe "topic pages" do
    
    #let(:user) { FactoryGirl.create(:user) }
    #before { @project = user.projects.build(title: "Lorem ipsum", summary: "My rails project") }   
    
    describe "users topic page" do
      let(:user) { create_logged_in_user } 
      let(:other_user) { FactoryGirl.create(:user, name: "foo_other", email: "other@foo.com", password: "other_foo", password_confirmation: "other_foo") }
      let!(:t3) { FactoryGirl.create(:topic, user: other_user, title: "topic3", summary: "football") }
      
      before do        
        visit user_topic_path(other_user, t3)
      end
      
      subject{page}
      
      it { should have_selector('h3', text: 'Topic details page') }
      it { should have_selector('h1', text: t3.title) }
      it { should have_selector('p', text: t3.summary) }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end    
  end

end