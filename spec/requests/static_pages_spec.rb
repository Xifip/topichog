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
  

end
