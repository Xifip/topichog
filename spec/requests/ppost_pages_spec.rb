require 'spec_helper'
describe "Topic pages" do
  
  #subject { page }
  
  let(:user) { create_logged_in_user } 
  
  describe "project creation" do
    before { visit new_user_ppost_path(user) }
    
    describe "with invalid information" do
      it {page.should have_content "#{user.name}"}
      it {page.should have_content "New Project"}
     
      it "should not create a project" do
        expect { page.click_button "Submit project" }.to_not change(Post, :count)
        expect { page.click_button "Submit project" }.to_not change(Ppost, :count)
      end
      
      describe "error messages" do
        before { page.click_button "Submit project" }
        it { page.should have_content('error') }
      end      
    end
  
    describe "with valid information" do
      before do
         page.fill_in 'ppost_title', with: "Lorem ipsum"
         page.fill_in 'ppost_summary', with: "Ipsum lorem"
      end
      it "should create a project" do
        
        expect { page.click_button "Submit project" }.to change(Ppost, :count).by(1)
      end
      it "should create a post" do
        expect { page.click_button "Submit project" }.to change(Post, :count).by(1)
        
      end
    end
  end
  
  describe "project destruction" do
    
    describe "as correct user" do
      before do
        FactoryGirl.create(:post, user: user, postable: FactoryGirl.create(:ppost, title: "Foo", summary: "football")) 
        visit user_path(user)
      end
      it "should delete a post" do
        expect { click_link "delete post" }.to change(Post, :count).by(-1)        
      end
      
      it "should delete a project" do        
        expect { click_link "delete post" }.to change(Ppost, :count).by(-1)
      end
    end
  end
end