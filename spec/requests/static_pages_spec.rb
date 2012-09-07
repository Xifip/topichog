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
  
  describe "for signed-in users" do
    let(:user) { create_logged_in_user } 
    before do
      FactoryGirl.create(:topic, user: user, title: "Lorem ipsum", summary:"Dolor sit amet")
      FactoryGirl.create(:topic, user: user, title: "Dolor sit amet", summary: "Lorem ipsum")
      #sign_in user
      visit root_path
    end
    
    it "should render the user's topic feed" do
      user.topic_feed.each do |item|
        page.should have_selector("li##{item.id}", text: item.title)
      end
    end
  end

end
