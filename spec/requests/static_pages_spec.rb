require 'spec_helper'

describe "Static pages" do
  
  subject { page }
  
  describe "Help page" do
    before { visit help_path }
    it { should have_selector('title', text: full_title('Help')) }
  end 
  
  describe "for non signed-in users" do
    describe "Home page" do
      let(:user) { FactoryGirl.create(:user) }
      before { visit root_path }
      it { should have_selector('h1',
            text: 'TopicHog Beta') }
      it { should have_xpath("//img[@src=\"/assets/wild-boar.png\"]") }
      it { should have_selector('title', text: full_title('')) }
      it { should_not have_selector 'title', text: '| Home' }
      it { should_not have_link(user.name, href: user_path(user)) }
      it { should_not have_link("new topic", href: new_user_topic_path(user)) }
      it { should_not have_link("new project", 
                                 href: new_user_project_path(user)) }
    end 
  end
  
  describe "for signed-in users" do
    describe "Home page" do
      let(:user) { create_logged_in_user } 
      before do
        FactoryGirl.create(:post, user: user, postable: 
              (FactoryGirl.create(:project, title: "Foo", summary: "football"))) 
        visit root_path
      end
      subject{page}
      it { should have_selector('title', text: full_title('')) }
      it { should_not have_selector 'title', text: '| Home' }
      it { should have_link(user.name, href: user_path(user)) }
      it { should have_link('view my profile', href: user_path(user)) }
      it { should have_link("new topic", href: new_user_topic_path(user)) }
      it { should have_link("new project", href: new_user_project_path(user)) }
      it "should render the user's post feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.postable.title)
        end
      end
      
      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end
        
        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
      
      describe "like counts and feed" do
        let(:other_user) { FactoryGirl.create(:user) }
        let(:liked_post) { FactoryGirl.create(:post, user: other_user, postable: 
              (FactoryGirl.create(:topic, title: "Foo", summary: "football"))) }
        before do
          user.like!(liked_post)
          visit root_path
        end

        it { should have_selector("h3", text: "Favorited items") }
        it "should render the user's liked posts feed" do
          user.liked_posts.each do |item|
            page.should have_selector("li##{item.id}", text: item.postable.title)
          end
        end      
      end
      
    end
  end
end
