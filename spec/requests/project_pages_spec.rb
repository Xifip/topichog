require 'spec_helper'
describe "Project pages" do
  
  #subject { page }
  
  let(:user) { create_logged_in_user } 
  
  describe "project viewing" do
   
    let(:post ) { FactoryGirl.create(:post, user: user, postable: FactoryGirl.create(:project, title: "Foo", summary: "football"))  }
    before { visit user_project_path(user, post.postable) }    
    
    subject {page} 
    
    describe "shows user and project info" do
      it { should have_selector('h1', text: user.name) }
      it { should have_content ( post.postable.title) }
      it { should have_content ( post.postable.summary) }
      it { should have_link('view profile', href: user_path(user)) }
    end
    
    
  end
  
  describe "shows likers and liker count" do
    let(:other_user) { FactoryGirl.create(:user) }
    let(:liked_post) { FactoryGirl.create(:post, user: other_user, postable: 
            (FactoryGirl.create(:project, title: "Foo", summary: "football"))) }
              
    before do
      user.like!(liked_post)
      visit user_project_path(other_user, liked_post.postable)
    end
    
    subject {page} 
    
    it { should have_selector('div.post_stats', text: liked_post.likes_count.to_s)}
    it "should render the list of users who like the post" do
      liked_post.likers.each do |item|
        should have_link('', href: user_path(item))
      end
    end    
    
    describe "like/unlike buttons" do
      describe "unliking a post" do  
        it "should decrement the user's liked posts count" do
          expect do
            click_button "Unfavorite"
          end.to change(user.liked_posts, :count).by(-1)
        end
        
        it "should decrement the post's likes count" do
          expect do
            click_button "Unfavorite"
          end.to change(liked_post.likes, :count).by(-1)
        end    
        
        describe "toggling the button" do
          before do 
            click_button "Unfavorite"           
          end          
          it { should have_selector('input', value: 'Favorite') }
          it { should have_selector('strong#liking', 
               text: liked_post.likes_count.to_s) } 
          it { should_not have_selector('a#liker_id_' + user.id.to_s) }
        end
      end  
      
      describe "liking a project" do
        before do
          user.unlike!(liked_post)
          visit user_project_path(other_user, liked_post.postable)
        end
        it "should increment the user's liked posts count" do
          expect do
            click_button "Favorite"
          end.to change(user.likes, :count).by(1)
        end
      
        it "should increment the post's likes count" do
          expect do
            click_button "Favorite"
          end.to change(liked_post.likes, :count).by(1)
        end    
        
        describe "toggling the button" do
          before { click_button "Favorite" }
          it { should have_selector('input', value: 'Unfavorite') }
          it { should have_selector('strong#liking', 
               text: liked_post.likes_count.to_s) } 
          it { page.should have_selector('a#liker_id_' + user.id.to_s) }          
        end
      end
    end
    
    describe "shows user and project info" do
      it { should have_selector('h1', text: other_user.name) }
      it { should have_content ( liked_post.postable.title) }
      it { should have_content ( liked_post.postable.summary) }
      it { should have_link('view profile', href: user_path(other_user)) }
    end 
  end
    
  describe "project creation" do
    before { visit new_user_project_path(user) }
    
    subject {page}
    
    describe "shows user info" do
      it { should have_selector('title', text: full_title(user.name + ' | new project')) }
      it { should have_selector('h1', text: user.name) }
    end
    
    describe "with invalid information" do
      it {page.should have_content "#{user.name}"}
      it {page.should have_content "New Project"}
     
      it "should not create a project" do
        expect { page.click_button "Submit project" }.to_not change(Post, :count)
        expect { page.click_button "Submit project" }.to_not change(Project, :count)
      end
      
      describe "error messages" do
        before { page.click_button "Submit project" }
        it { page.should have_content('error') }
      end      
    end
  
    describe "with valid information" do
      before do
         page.fill_in 'project_title', with: "Lorem ipsum"
         page.fill_in 'project_summary', with: "Ipsum lorem"
      end
      it "should create a project" do
        
        expect { page.click_button "Submit project" }.to change(Project, :count).by(1)
      end
      it "should create a post" do
        expect { page.click_button "Submit project" }.to change(Post, :count).by(1)
        
      end
    end
  end
  
  describe "project destruction" do

    describe "as correct user" do
      before do
        FactoryGirl.create(:post, user: user, postable: FactoryGirl.create(:project, title: "Foo", summary: "football")) 
        visit user_path(user)
      end
      it "should delete a post" do
        expect { click_link "delete" }.to change(Post, :count).by(-1)        
      end
      
      it "should delete a project" do        
        expect { click_link "delete" }.to change(Project, :count).by(-1)
      end
    end
  end
 
end
