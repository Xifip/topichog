require 'spec_helper'
  describe "User pages" do
    subject { page }
    describe "signup page" do
      before { visit new_user_registration_path }
      it { should have_selector('h2', text: 'Sign up') }    
    end
    describe "profile page" do
      # Code to make a user variable
      #let(:user) { FactoryGirl.create(:user) }
      before(:each) do
      @test_user = FactoryGirl.create(:user)
      end      
      before { visit new_user_registration_path }
      it { should have_selector('h2', text: 'Sign up') }  
      it "has user email" do
         debugger
         page.should have_selector('h2', text: @test_user.email) 
      end    
    end
end