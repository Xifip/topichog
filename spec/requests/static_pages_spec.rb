require 'spec_helper'

describe "StaticPages" do
  describe "Home pages" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
    it "should have the content 'TopicHog Beta'" do
      visit root_path
      page.should have_content('TopicHog Beta')
    end
    
    it "should have the logo image 'topichog.png'" do
      visit root_path
      page.should have_xpath("//img[@src=\"/assets/wild-boar.png\"]")
    end
  end
  
  describe "Help page" do
    it "should have the content 'TopicHog Help page'" do
      visit help_path
      page.should have_content('TopicHog Help page')
    end
  end
  
  describe "for non signed-in users" do
    let(:user) { FactoryGirl.create(:user) } 
    before do    
      visit root_path
    end
    subject{page}

    it { should_not have_link(user.name, href: user_path(user)) }
    it { should_not have_link("new topic", href: new_user_topic_path(user)) }
    it { should_not have_link("new project", href: new_user_project_path(user)) }
  end
  
  describe "for signed-in users" do
    let(:user) { create_logged_in_user } 
    before do
      FactoryGirl.create(:post, user: user, postable: (FactoryGirl.create(:ppost, title: "Foo", summary: "football"))) 
      visit root_path
    end
    subject{page}

    it { should have_link(user.name, href: user_path(user)) }
    it { should have_link("new topic", href: new_user_topic_path(user)) }
    it { should have_link("new project", href: new_user_project_path(user)) }
    it "should render the user's post feed" do
      user.feed.each do |item|
        page.should have_selector("li##{item.id}", text: item.postable.title)
      end
    end
  end

end
