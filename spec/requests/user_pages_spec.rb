require 'spec_helper'
require "debugger"


describe "User pages" do
  
  subject {page}
 
  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:all) { 30.times { FactoryGirl.create(:user) } }
    after(:all) { User.delete_all }
    before(:each) do
      create_logged_in_user
      visit users_path
    end
    it { should have_selector('title', text: full_title('All users')) }
    it { should have_selector('h3',
    text: 'Users list') }
    describe "pagination" do
      it { should have_selector('div.pagination') }
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
       end
      end
    end
  end

  
  describe "profile page with posts" do 
    
    let(:user) { create_logged_in_user } 
    
    let(:profile) { FactoryGirl.create(:profile, user: user) }
    
    let!(:p1) { FactoryGirl.create(:ppost, title: "project1", summary: "football") }
    let!(:post1) { FactoryGirl.create(:post, user: user, postable: p1) }
    
    let!(:p2) { FactoryGirl.create(:project, title: "project2", summary: "barley") }
    let!(:post2) { FactoryGirl.create(:post, user: user, postable: p2) }
    
    let!(:t1) { FactoryGirl.create(:tpost, title: "topic1", summary: "football") }
    let!(:post3) { FactoryGirl.create(:post, user: user, postable: t1) }
    
    let!(:t2) { FactoryGirl.create(:topic, title: "topic2", summary: "barley") }
    let!(:post4) { FactoryGirl.create(:post, user: user, postable: t2) }
    
  

    describe "should show the correct user profile and posts" do
      before do
       user.profile = profile
       visit user_path(user) 
      end
      subject {page}
      it { should have_selector('title', text: full_title(user.name)) }
      it { should have_selector('h1', text: user.name) }
      it { should_not have_link('view my profile', href: user_path(user)) }
      it { should have_link('edit profile', href: edit_profile_path(user)) }  
      it { should have_content(user.profile.bio) }
      it { should have_link('my twitter', href: user.profile.twitter_url) }
      it { should have_link('my facebook', href: user.profile.facebook_url) }
      it { should have_link('my linkedin', href: user.profile.linkedin_url) }      
      it { should have_link('my site', href: user.profile.mysite_url) }  
      it { should have_link('my blog', href: user.profile.myblog_url) }     
      #it { should have_content(p1.title) }
      it { should have_content(p2.title) }    
      #it { should have_content(t1.title) }
      it { should have_content(t2.title) }
      it { should have_content(user.posts.find_all_by_postable_type("Topic").count) }
      it { should have_content(user.posts.find_all_by_postable_type("Project").count) }
    end   
    
    describe "vist another user's profile" do
      let(:user) { create_logged_in_user } 
      let!(:other_user) { FactoryGirl.create(:user, name: "foo_other", email: "other@foo.com", password: "other_foo", password_confirmation: "other_foo") }
      let!(:profile) { FactoryGirl.create(:profile, user: other_user, bio: "other user bio", mysite_url: "http://www.topichog.com") }      
      let(:p1) { FactoryGirl.create(:project, title: "Foo", summary: "football") }
      let(:post1) { FactoryGirl.create(:post, user: other_user, postable: p1) }
      
      describe "shows the correct user profile and posts" do
        before do
         other_user.profile = profile
         visit user_path(other_user) 
        end
        subject {page}
        it { should_not have_selector('h1', text: user.name) }
        it { should_not have_link('view my profile', href: user_path(other_user))}
        it { should_not have_link('edit profile', href: edit_profile_path(user)) }         
        it { should have_selector('title', text: full_title(other_user.name)) }      
        it { should have_selector('h1', text: other_user.name) }
        it { should have_content(other_user.profile.bio) }
        it { should have_link('my twitter', href: other_user.profile.twitter_url) }
        it { should have_link('my facebook', href: other_user.profile.facebook_url) }
        it { should have_link('my linkedin', href: other_user.profile.linkedin_url) }      
        it { should have_link('my site', href: other_user.profile.mysite_url) } 
        it { should have_link('my blog', href: other_user.profile.myblog_url) }           
        it { should have_content(p1.title) }
        it { should have_content(other_user.posts.find_all_by_postable_type("Topic").count) }
        it { should have_content(other_user.posts.find_all_by_postable_type("Project").count) }
      end
    end
    
    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user, name: "foo_other", email: "other@foo.com", password: "other_foo", password_confirmation: "other_foo") }
      
      describe "following a user" do
        before { visit user_path(other_user) }
       
        it { page.should have_selector('title', text: full_title(other_user.name)) }  
        it "should increment the followed user count" do
          page.should have_selector('input', value: 'Follow')
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end
        
        describe "follower email notification" do
        
          before do
            reset_email
            click_button "Follow"  
          end
          
          it "should have a link to the follower" do
            last_email.body.encoded.should have_link(user.name, href: user_url(user, host: 'localhost:3000'))
          end
          it { last_email.to.should include(other_user.email) }
          it { last_email.from.should include("no-reply@topichog.com") }
          it { last_email.subject.should eq(user.name + " followed you on TopicHog!") }
          it { last_email.body.encoded.should include(user.name) }
          it { last_email.body.encoded.should include(" is now following you on TopicHog") }
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

=begin    
  describe "project pages ppost" do
    
    describe "users project page" do
      let(:user) { create_logged_in_user } 
      let(:other_user) { FactoryGirl.create(:user, name: "foo_other", email: "other@foo.com", password: "other_foo", password_confirmation: "other_foo") }
      let!(:p1) { FactoryGirl.create(:ppost, title: "Foo", summary: "football") }
      let!(:post1) { FactoryGirl.create(:post, user: other_user, postable: p1) }
      before do        
        visit user_ppost_path(other_user, p1)
      end
      
      subject{page}
      it { page.should have_selector('title', text: full_title(other_user.name + ' | ' + p1.title)) } 
      it { should have_content(p1.title) }
      it { should have_content(p1.summary) }
      it { should have_link('view profile', href: user_path(other_user)) }
      
    end    
  end


  describe "topic pages tpost" do   
    
    describe "users topic page" do
      let(:user) { create_logged_in_user } 
      let(:other_user) { FactoryGirl.create(:user, name: "foo_other", email: "other@foo.com", password: "other_foo", password_confirmation: "other_foo") }
      let!(:t3) { FactoryGirl.create(:tpost, title: "topic3", summary: "football") }
      let!(:post2) { FactoryGirl.create(:post, user: other_user, postable: t3) }
      
      before do        
        visit user_tpost_path(other_user, t3)
      end
      
      subject{page}
      
      it { page.should have_selector('title', text: full_title(other_user.name + ' | ' + t3.title)) } 
      it { should have_content(t3.title) }
      it { should have_content(t3.summary) }
      it { should have_link('view profile', href: user_path(other_user)) }
    end    
  end
=end  
  describe "project pages" do
    
    describe "users project page" do
      let(:user) { create_logged_in_user } 
      let(:other_user) { FactoryGirl.create(:user, name: "foo_other", email: "other@foo.com", password: "other_foo", password_confirmation: "other_foo") }
      let!(:p2) { FactoryGirl.create(:project, title: "Foo", summary: "football") }
      let!(:post3) { FactoryGirl.create(:post, user: other_user, postable: p2) }
      
      before do  
        #debugger      
        visit user_project_path(other_user, post3)
      end
      
      subject{page}
      
      it { page.should have_selector('title', text: full_title(other_user.name + ' | ' + p2.title)) } 
      it { should have_content(p2.title) }
      it { should have_content(p2.summary) }
      it { should have_link('view profile', href: user_path(other_user)) }
    end    
  end
  
  describe "topic pages" do 
    
    describe "users topic page" do
      let(:user) { create_logged_in_user } 
      let(:other_user) { FactoryGirl.create(:user, name: "foo_other", 
                        email: "other@foo.com", password: "other_foo", 
                        password_confirmation: "other_foo") }
      let!(:t2) { FactoryGirl.create(:topic, title: "topic2", 
                  summary: "football") }
      let!(:post4) { FactoryGirl.create(:post, user: other_user, postable: t2) }
      
      before do        
        visit user_topic_path(other_user, post4)
      end
      
      subject{page}
      
      it { page.should have_selector('title', 
                      text: full_title(other_user.name + ' | ' + t2.title)) } 
      it { should have_content(t2.title) }
      it { should have_content(t2.summary) }
      it { should have_link('view profile', href: user_path(other_user)) }
    end    
  end

  describe "like counts and feed" do
    let(:user) { create_logged_in_user } 
    let(:other_user) { FactoryGirl.create(:user) }
    let(:liked_post) { FactoryGirl.create(:post, user: other_user, postable: 
              (FactoryGirl.create(:topic, title: "Foo", summary: "football"))) }
    before do
      user.like!(liked_post)
      visit user_path(user)
    end

    subject{page}    

    it { should have_selector("h3", text: "Favorited items") }
    it "should render the user's liked posts feed" do
      user.liked_posts.each do |item|
        page.should have_selector("li##{item.id}", text: item.postable.title)
      end
    end      
  end
end
