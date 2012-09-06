require 'spec_helper'
describe "Topic pages" do
  
  #subject { page }
  
  #let(:user) { FactoryGirl.create(:user) }
  #before { sign_in user }
  let(:user) { create_logged_in_user } 
  
  describe "topic creation" do
    before { visit new_user_topic_path(user) }
    #before { visit user_path(user) }
    #before { visit root_path }
    #before do
    #  visit user_path(user)
    #  click_link "Home"
    #end
    
    describe "with invalid information" do
      it {page.should have_content "#{user.name}"}
      it {page.should have_content "New Topic"}
     
      it "should not create a topic" do
        expect { page.click_button "Submit topic" }.to_not change(Topic, :count)
      end
      
      describe "error messages" do
        before { page.click_button "Submit topic" }
        it { page.should have_content('error') }
      end      
    end
  
    describe "with valid information" do
      before do
         page.fill_in 'topic_title', with: "Lorem ipsum"
         page.fill_in 'topic_summary', with: "Ipsum lorem"
      end
      it "should create a topic" do
        expect { page.click_button "Submit topic" }.to change(Topic, :count).by(1)
      end
    end
  end
end