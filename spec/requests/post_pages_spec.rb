require 'spec_helper'
require "debugger"


describe "Post pages" do
  
  
  describe "explore page as a non-signed in user" do 
    
    let!(:user) { FactoryGirl.create(:user, name: "foo_not_signed_in", email: "not_signed_in@foo.com", password: "not_signed_in_foo", password_confirmation: "not_signed_in_foo") }
    #let(:user) { create_logged_in_user } 
    let(:profile) { FactoryGirl.create(:profile, user: user) }    
   
    let!(:other_user) { FactoryGirl.create(:user, name: "foo_other", email: "other@foo.com", password: "other_foo", password_confirmation: "other_foo") }   
    let(:other_profile) { FactoryGirl.create(:profile, user: other_user) }    

    let!(:p1) { FactoryGirl.create(:project, title: "project1", summary: "barley") }
    let!(:post1) { FactoryGirl.create(:post, user: other_user, postable: p1) }
    
    let!(:t1) { FactoryGirl.create(:topic, title: "topic1", summary: "barley") }
    let!(:post3) { FactoryGirl.create(:post, user: other_user, postable: t1) }

    let!(:p2) { FactoryGirl.create(:project, title: "project2", summary: "barley") }
    let!(:post2) { FactoryGirl.create(:post, user: user, postable: p2) }
    
    let!(:t2) { FactoryGirl.create(:topic, title: "topic2", summary: "barley") }
    let!(:post4) { FactoryGirl.create(:post, user: user, postable: t2) }
    
    let (:feed_items) { Post.all }
    
    before { visit posts_path }

    subject {page}
    
    it { page.should have_selector('title', text: full_title('explore topics and projects')) }
    it { should have_content("Feed")}
    it { should have_content("topic1")}
    it { should have_content("topic2")}
    it { should have_content("project1")}
    it { should have_content("project2")}
    
    it "should render the user's post feed" do
      feed_items.each do |item|
        page.should have_selector("li##{item.id}", text: item.postable.title)
      end
    end
  end
  
  describe "explore page as a signed in user" do 
    
    let(:user) { create_logged_in_user } 
    let(:profile) { FactoryGirl.create(:profile, user: user) }    
   
    let!(:other_user) { FactoryGirl.create(:user, name: "foo_other", email: "other@foo.com", password: "other_foo", password_confirmation: "other_foo") }   
    let(:other_profile) { FactoryGirl.create(:profile, user: other_user) }    

    let!(:p1) { FactoryGirl.create(:project, title: "project1", summary: "barley") }
    let!(:post1) { FactoryGirl.create(:post, user: other_user, postable: p1) }
    
    let!(:t1) { FactoryGirl.create(:topic, title: "topic1", summary: "barley") }
    let!(:post3) { FactoryGirl.create(:post, user: other_user, postable: t1) }

    let!(:p2) { FactoryGirl.create(:project, title: "project2", summary: "barley") }
    let!(:post2) { FactoryGirl.create(:post, user: user, postable: p2) }
    
    let!(:t2) { FactoryGirl.create(:topic, title: "topic2", summary: "barley") }
    let!(:post4) { FactoryGirl.create(:post, user: user, postable: t2) }
    
    let (:feed_items) { Post.all }
    
    before { visit posts_path }

    subject {page}
    
    it { page.should have_selector('title', text: full_title('explore topics and projects')) }
    it { should have_content("Feed")}
    it { should have_content("topic1")}
    it { should have_content("topic2")}
    it { should have_content("project1")}
    it { should have_content("project2")}
    
    it "should render the user's post feed" do
      feed_items.each do |item|
        page.should have_selector("li##{item.id}", text: item.postable.title)
      end
    end
  end
end

