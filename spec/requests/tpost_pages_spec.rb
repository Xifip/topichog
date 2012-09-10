require 'spec_helper'
describe "Topic pages" do
  
  #subject { page }
  
  let(:user) { create_logged_in_user } 
  
  describe "topic creation" do
    before { visit new_user_tpost_path(user) }
    
    describe "with invalid information" do
      it {page.should have_content "#{user.name}"}
      it {page.should have_content "New Topic"}
     
      it "should not create a topic" do
        expect { page.click_button "Submit topic" }.to_not change(Post, :count)
        expect { page.click_button "Submit topic" }.to_not change(Tpost, :count)
      end
      
      describe "error messages" do
        before { page.click_button "Submit topic" }
        it { page.should have_content('error') }
      end      
    end
  
    describe "with valid information" do
      before do
         page.fill_in 'tpost_title', with: "Lorem ipsum"
         page.fill_in 'tpost_summary', with: "Ipsum lorem"
      end
      it "should create a topic" do
        expect { page.click_button "Submit topic" }.to change(Post, :count).by(1)
        expect { page.click_button "Submit topic" }.to change(Tpost, :count).by(1)
      end
    end
  end
  
  describe "topic destruction" do
    before do           
      FactoryGirl.create(:post, user: user, postable: FactoryGirl.create(:tpost, title: "Foo", summary: "football")) 
    end
    describe "as correct user" do
      before { visit user_path(user) }
      it "should delete a post" do
        expect { click_link "delete post" }.to change(Post, :count).by(-1)        
      end
      
      it "should delete a topic" do        
        expect { click_link "delete post" }.to change(Tpost, :count).by(-1)
      end
    end
  end
end