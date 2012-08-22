require 'spec_helper'
  describe "User pages" do
    subject { page }
    describe "signup page" do
    before { visit new_user_registration_path }
    it { should have_selector('h2', text: 'Sign up') }
    
  end
  describe "profile page" do
  # Code to make a user variable
  before { visit new_user_registration_path }
  it { should have_selector('h2', text: user.name) }
  
  end
end