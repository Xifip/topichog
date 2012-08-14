require 'spec_helper'

describe "StaticPages" do
  describe "Home pages" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
    it "should have the content 'Product Innovator assessment app'" do
      visit root_path
      page.should have_content('Product Innovator assessment app')
    end
  end
  
  describe "Help page" do
    it "should have the content 'Help page'" do
      visit help_path
      page.should have_content('Help page')
    end
  end
end
