require 'spec_helper'
require "debugger"

describe "User pages" do

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:project, user: user, title: "Foo", summary: "football") }
    let!(:m2) { FactoryGirl.create(:project, user: user, title: "Bar", summary: "barley") }
    #before "visit user profile" do
    #   visit user_path(user) 
    #end
    before { visit user_path(user) }
    
    it { page.should have_selector('h1', text: user.name) }
    
    describe "projects" do
      it { page.should have_content(m1.title) }
      it { page.should have_content(m2.title) }
      it { page.should have_content(user.projects.count) }
    end
  end

end