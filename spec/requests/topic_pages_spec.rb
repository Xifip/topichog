require 'spec_helper'
describe "Topic pages" do
  
  #subject { page }
  
  let(:user) { create_logged_in_user } 
  
  describe "topic viewing" do
   
    let(:post ) { FactoryGirl.create(:post, user: user, postable: 
      FactoryGirl.create(:topic, title: "Foo", summary: "football"))  }
    before { visit user_topic_path(user, post.postable) }    
    
    subject {page} 
    
    describe "shows user info" do
      it { should have_selector('h1', text: user.name) }
      it { should have_content ( post.postable.title) }
      it { should have_content ( post.postable.summary) }
      it { should have_link('view my profile', href: user_path(user)) }
    end
  end
  
  describe "shows likers and liker count" do
    let(:other_user) { FactoryGirl.create(:user) }
    let(:liked_post) { FactoryGirl.create(:post, user: other_user, postable: 
            (FactoryGirl.create(:topic, title: "Foo", summary: "football"))) }
              
    before do
      user.like!(liked_post)
      visit user_topic_path(other_user, liked_post.postable)
    end
    
    subject {page}     

    it { should have_selector('div.post_stats', 
                              text: liked_post.likes_count.to_s)}
    it "should render the list of users who like the post" do
      liked_post.likers.each do |item|
        should have_link('', href: user_path(item))
      end
    end   
    
    describe "shows user and topic info" do
      it { should have_selector('h1', text: other_user.name) }
      it { should have_content ( liked_post.postable.title) }
      it { should have_content ( liked_post.postable.summary) }
      it { should have_link('view my profile', href: user_path(other_user)) }
    end 
  end
  
  describe "topic creation" do
    before { visit new_user_topic_path(user) }
    
    subject {page}
    
    describe "shows user info" do
      it { should have_selector('title', 
                                text: full_title(user.name + ' | new topic')) }
      it { should have_selector('h1', text: user.name) }      
    end
    
    describe "with invalid information" do
      it {page.should have_content "#{user.name}"}
      it {page.should have_content "New Topic"}
     
      it "should not create a topic" do
        expect { page.click_button "Submit topic" }.to_not change(Post, :count)
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
      it "should create a post" do
        expect { page.click_button "Submit topic" }.to change(Post, :count).by(1)
        
      end
    end
  end
  
  describe "topic destruction" do

    describe "as correct user" do
      before do
        FactoryGirl.create(:post, user: user, postable: 
          FactoryGirl.create(:topic, title: "Foo", summary: "football")) 
        visit user_path(user)
      end
      it "should delete a post" do
        expect { click_link "delete" }.to change(Post, :count).by(-1)        
      end
      
      it "should delete a topic" do        
        expect { click_link "delete" }.to change(Topic, :count).by(-1)
      end
    end
  end
  
  
end
