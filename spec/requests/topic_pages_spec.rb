require 'spec_helper'
describe "Topic pages" do
  
  #subject { page }
  
  let(:user) { create_logged_in_user } 
  
  describe "topic viewing" do
   
    let(:post ) { FactoryGirl.create(:post, user: user, postable: 
      FactoryGirl.create(:topic, title: "Foo", summary: "football",
      topicdraft: FactoryGirl.create(:topicdraft, title: "Foo", 
          summary: "football", user: user)))  }
    before { visit user_topic_path(user, post.postable) }    
    
    subject {page} 
    
    describe "shows user info and topic" do
      it { should have_selector('h4', text: user.name) }
      it { should have_content ( post.postable.title) }
      it { should have_content ( post.postable.summary) }
      #user nokogiri or elementor to scrap content  
      it { should have_content ( 'My topic reference') }
      it { should have_content ( 'My topic content') }
      it { should have_link('view profile', href: user_path(user)) }
      it { should have_link('edit topic', href: edit_user_topicdraft_path(user, post.postable.topicdraft)) }
      it { should have_link('My topic reference', href: 'http://www.google.com') }
    end    
  end
  
  describe "viewing another users topic" do
    let(:other_user) { FactoryGirl.create(:user) }
    let(:post ) { FactoryGirl.create(:post, user: other_user, postable: 
      FactoryGirl.create(:topic, title: "Foo", summary: "football"))  }
    before do
     #debugger
     visit user_topic_path(other_user, post.postable)
   end
    
    subject {page} 
    
    describe "shows user and topic info" do
      it { should have_selector('h4', text: other_user.name) }
      it { should have_content ( post.postable.title) }
      it { should have_content ( post.postable.summary) }
      #user nokogiri or elementor to scrap content  
      it { should have_content ( 'My topic reference') }
      it { should have_content ( 'My topic content') }
      it { should have_link('view profile', href: user_path(other_user)) }
      it { should_not have_link('edit topic', href: edit_user_topicdraft_path(user, post)) }
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
      it { should have_selector('h4', text: other_user.name) }
      it { should have_content ( liked_post.postable.title) }
      it { should have_content ( liked_post.postable.summary) }
      it { should have_link('view profile', href: user_path(other_user)) }
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
        FactoryGirl.create(:post, user: user, 
        postable: FactoryGirl.create(:topic, title: "Foo", summary: "football",
        topicdraft: FactoryGirl.create(:topicdraft, title: "Foo", 
          summary: "football", user: user)))
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

      it "should delete a topicdraft" do        
        expect { click_link "delete" }.to change(Topicdraft, :count).by(-1)
      end
      
      it "should not delete a topic" do        
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
  
end
