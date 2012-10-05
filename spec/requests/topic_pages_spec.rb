require 'spec_helper'
describe "Topic pages" do
  
  #subject { page }
  
  let(:user) { create_logged_in_user } 
  
  describe "topic viewing" do
   
    let(:post ) { FactoryGirl.create(:post, user: user, postable: 
      FactoryGirl.create(:topic, title: "Foo", summary: "football"))  }
    before { visit user_topic_path(user, post.postable) }    
    
    subject {page} 
    
    describe "shows user info and topic" do
      it { should have_selector('h1', text: user.name) }
      it { should have_content ( post.postable.title) }
      it { should have_content ( post.postable.summary) }
      #user nokogiri or elementor to scrap content  
      it { should have_content ( 'My topic reference') }
      it { should have_content ( 'My topic content') }
      it { should have_link('view profile', href: user_path(user)) }
      it { should have_link('edit topic', href: edit_user_topic_path(user, post.postable)) }
      it { should have_link('My topic reference', href: 'http://www.google.com') }
    end    
  end
  
  describe "viewing another users topic" do
    let(:other_user) { FactoryGirl.create(:user) }
    let(:post ) { FactoryGirl.create(:post, user: other_user, postable: 
      FactoryGirl.create(:topic, title: "Foo", summary: "football"))  }
    before { visit user_topic_path(other_user, post.postable) }    
    
    subject {page} 
    
    describe "shows user and topic info" do
      it { should have_selector('h1', text: other_user.name) }
      it { should have_content ( post.postable.title) }
      it { should have_content ( post.postable.summary) }
      #user nokogiri or elementor to scrap content  
      it { should have_content ( 'My topic reference') }
      it { should have_content ( 'My topic content') }
      it { should have_link('view profile', href: user_path(other_user)) }
      it { should_not have_link('edit topic', href: edit_user_topic_path(user, post.postable)) }
      it { should have_link('My topic reference', href: 'http://www.google.com') }
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
      
      describe "liking a topic" do
        before do
          user.unlike!(liked_post)
          visit user_topic_path(other_user, liked_post.postable)
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
        
        describe "like email notification" do
        
          before do
            reset_email
            click_button "Favorite"  
          end
          
          it "should have a link to the liker" do
            last_email.body.encoded.should have_link(user.name, href: user_url(user, host: 'localhost:3000'))
          end
          it { last_email.to.should include(other_user.email) }
          it { last_email.from.should include("no-reply@topichog.com") }
          it { last_email.subject.should eq(user.name + " liked '" + liked_post.postable.title + "' on TopicHog!") }
          it { last_email.body.encoded.should include(user.name) }
          it { last_email.body.encoded.should include("liked '" + liked_post.postable.title + "' on TopicHog!") }
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
    
    describe "shows user and topic info" do
      it { should have_selector('h1', text: other_user.name) }
      it { should have_content ( liked_post.postable.title) }
      it { should have_content ( liked_post.postable.summary) }
      it { should have_link('view profile', href: user_path(other_user)) }
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
         page.fill_in 'Title', with: "Lorem ipsum"
         page.fill_in 'Summary', with: "Ipsum lorem"
         page.fill_in 'content_textarea', with: "Ipsum lorem"
         page.fill_in 'reference_textarea', with: "Ipsum lorem"
         page.fill_in 'Tags', with: "tag1, tag2, tag3"
      end
      it "should create a topic" do
        
        expect { page.click_button "Submit topic" }.to change(Topic, :count).by(1)
      end
      it "should create a post" do
        expect { page.click_button "Submit topic" }.to change(Post, :count).by(1)        
      end
      
      describe "tag creation" do
        before {page.click_button "Submit topic"}
         it "should create topic tags" do  
          Topic.last.tag_list.should eq([ "tag1", "tag2", "tag3" ])
        end
        it "should create post tags" do          
          Topic.last.posts[0].owner_tags_on(user, :tags).should eq(Topic.last.tags)
        end
      end  

    end
  end
  
  describe "topic destruction" do
    describe "as incorrect user" do
    
      let(:other_user) { FactoryGirl.create(:user) }
      
      before do
        FactoryGirl.create(:post, user: other_user, postable: 
          FactoryGirl.create(:topic, title: "Foo", summary: "football")) 
        visit user_path(other_user)
      end
      
      subject {page}
      
      it { should_not have_link('delete', href: post_path(Post.last), method: :delete) }
      
    end

    describe "as correct user" do
      before do
        FactoryGirl.create(:post, user: user, postable: 
          FactoryGirl.create(:topic, title: "Foo", summary: "football")) 
        visit user_path(user)
      end
      
      subject {page}
      
      it { should have_link('delete', href: post_path(Post.last), method: :delete) }
      
      it "should delete a post" do
        expect { click_link "delete" }.to change(Post, :count).by(-1)        
      end
      
      it "should delete a topic" do        
        expect { click_link "delete" }.to change(Topic, :count).by(-1)
      end
      
      it "should not delete a project" do        
        expect { click_link "delete" }.to_not change(Project, :count)
      end
      
      describe "tag destruction" do
        before {page.click_link "delete"}
        it "should not find tags in topic model" do          
          Topic.tag_counts.should eq([ ])
        end
        it "should not find tags in post model" do          
          Post.tag_counts.should eq([ ])
        end
        it "should not find tags for user" do       
          user.owned_tags.should eq([ ])
        end
         it "should not find topic with tags" do          
          Topic.tagged_with("tag1").should eq([ ])
        end
         it "should not find post with tags" do          
          Post.tagged_with("tag1").should eq([ ])
        end
      end  
      
    end
  end 
  
  describe "topic editing" do

    describe "as correct user" do
      let(:post) {FactoryGirl.create(:post, user: user, postable: 
          FactoryGirl.create(:topic, title: "Foo", summary: "football")) }
      before do        
        visit edit_user_topic_path(user, post.postable)
      end
      
      subject {page}
      
      describe "shows topic info" do
        it { should have_selector('title', text: full_title(user.name + ' | edit ' + post.postable.title)) }
        it { should have_selector('input', value: post.postable.title) }
        it { should have_selector('input', value: post.postable.summary) }
        it { should have_selector('input', value: post.postable.reference) }
        it { should have_selector('input', value: post.postable.content) }                
      end
      
      describe "with invalid information" do
        before do
           page.fill_in 'Title', with: ""
           page.click_button "Submit topic"
        end
       
        it "should not update the topic" do
          Topic.last.title.should_not eq(" ")
        end
        
        describe "error messages" do
          it { page.should have_content('error') }
        end      
      end
    
      describe "with valid information" do
        before do
           page.fill_in 'Title', with: "Lorem ipsum"
           page.fill_in 'Summary', with: "Ipsum lorem"
           page.fill_in 'content_textarea', with: "Ipsum lorem"
           page.fill_in 'reference_textarea', with: "Ipsum lorem"
           page.fill_in 'Tags', with: "tag1, tag2, tag3"
           page.click_button "Submit topic"
        end
        it "should update the topic" do        
          Topic.last.title.should eq("Lorem ipsum")
          Topic.last.summary.should eq("Ipsum lorem")
          Topic.last.content.should eq("Ipsum lorem")
          Topic.last.reference.should eq("Ipsum lorem")
          Topic.last.tag_list.should eq([ "tag1", "tag2", "tag3" ])                             
        end        

        it "should update the post" do        
          Topic.last.title.should eq(Post.last.postable.title)
          Topic.last.summary.should eq(Post.last.postable.summary)
          Topic.last.content.should eq(Post.last.postable.content)
          Topic.last.reference.should eq(Post.last.postable.reference)
          Topic.last.tags.should eq(Post.last.postable.tags)                              
        end   

      end
    end 
  end    
end
