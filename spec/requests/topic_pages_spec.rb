require 'spec_helper'
describe "Topic pages" do
  
  subject { page }
  
  #let(:user) { FactoryGirl.create(:user) }
  #before { sign_in user }
  let(:user) { create_logged_in_user } 
  
  describe "topic creation" do
    before { visit new_user_topic_path(user) }
  
    describe "with invalid information" do
      it "should not create a topic" do
        expect { click_button "Save" }.should_not change(Topic, :count)
      end
    
      describe "error messages" do
        before { click_button "Save" }
        it { should have_content('error') }
      end      
    end
  
    describe "with valid information" do
      before do
         fill_in 'topic_title', with: "Lorem ipsum"
         fill_in 'topic_summary', with: "Ipsum lorem"
      end
      it "should create a topic" do
        expect { click_button "Save" }.should change(Topic, :count).by(1)
      end
    end
  end
end