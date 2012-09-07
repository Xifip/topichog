require 'spec_helper'
describe "Topic pages" do
  
  #subject { page }
  
  let(:user) { create_logged_in_user } 
  
  describe "topic creation" do
    before { visit new_user_topic_path(user) }
    
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
  
  describe "topic destruction" do
    before { FactoryGirl.create(:topic, user: user) }
    describe "as correct user" do
      before { visit root_path }
      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Topic, :count).by(-1)
      end
    end
  end
end