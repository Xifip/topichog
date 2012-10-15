require 'spec_helper'
describe "Topicdraft pages" do
  let(:user) { create_logged_in_user } 
  
  describe "topicdraft creation" do
    before { visit new_user_topicdraft_path(user) }
    
    subject {page}
    
    describe "shows user info" do
      it { should have_selector('title', text: full_title(user.name + ' | new topic draft')) }
      it { should have_selector('h1', text: user.name) }
    end
    
    describe "with invalid information" do
      it {page.should have_content "#{user.name}"}
      it {page.should have_content "New Topic"}
     
      it "should not create a topic" do
        expect { page.click_button "Save draft topic" }.to_not change(Topicdraft, :count)
        expect { page.click_button "Save draft topic" }.to_not change(Post, :count)
        expect { page.click_button "Save draft topic" }.to_not change(Topic, :count)
      end
      
      describe "error messages" do
        before { page.click_button "Save draft topic" }
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
      it "should create a topicdraft" do        
        expect { page.click_button "Save draft topic" }.to change(Topicdraft, :count).by(1)
      end
      it "should not create a topic" do        
        expect { page.click_button "Save draft topic" }.to_not change(Topic, :count).by(1)
      end
      it "should not create a post" do
        expect { page.click_button "Save draft topic" }.to_not change(Post, :count).by(1)        
      end
      
      describe "associations created" do
       
       before { page.click_button "Save draft topic" }
      
       it "should have the right user assositations" do
        Topicdraft.last.user.should eq user
       end
             
      end
      describe "draft status" do
        before {page.click_button "Save draft topic"}
        it "draft is ahead of published" do
          Topicdraft.last.draft_ahead.should eq true 
        end
      end
      
      describe "tag creation" do
        before {page.click_button "Save draft topic"}
         it "should create topic tags" do            
          Topicdraft.last.tag_list.should include("tag1") 
          Topicdraft.last.tag_list.should include("tag2")
          Topicdraft.last.tag_list.should include("tag3")
        end
      end  
    end
  end
  
  
  describe "viewing own topicdraft" do
   
    let(:topicdraft ) { FactoryGirl.create(:topicdraft, title: "Foo", summary: "football", user: user) }
  
    before { visit user_topicdraft_path(user, topicdraft) }

    subject {page} 
    
    describe "shows user and topic info" do
      it { should have_selector('h1', text: user.name) }
      it { should have_content ( topicdraft.title) }
      it { should have_content ( topicdraft.summary) }
      #user nokogiri or elementor to scrap content  
      it { should have_content ( 'My topic reference') }
      it { should have_content ( 'My topic content') }
      it { should have_link('view profile', href: user_path(user)) }
      it { should have_link('edit draft topic', href: edit_user_topicdraft_path(user, topicdraft)) }
      it { should have_link('publish topic', href: publish_user_topicdraft_path(user, topicdraft)) }      
      it { should have_link('My topic reference', href: 'http://www.google.com') }
    end
    
    
  end
=begin
  describe "viewing another users topic" do
    let(:other_user) { FactoryGirl.create(:user) }
    let(:post ) { FactoryGirl.create(:post, user: other_user, postable: 
    FactoryGirl.create(:topic, title: "Foo", summary: "football"))  }
    #before { visit user_topic_path(other_user, post.postable) }    
    before { visit user_topic_path(other_user, post) }
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
=end  

  describe "topicdraft publication" do

    describe "publishing a draft for a new topic" do
    
    let(:topicdraft ) { FactoryGirl.create(:topicdraft, title: "Foo", summary: "football", user: user) }  
    before { visit user_topicdraft_path(user, topicdraft) }
    
    subject {page}      

      it "should create a topic" do        
        expect { page.click_link "publish topic" }.to change(Topic, :count).by(1)
      end
      it "should create a post" do
        expect { page.click_link "publish topic" }.to change(Post, :count).by(1)        
      end
      
      describe "updates topic values" do
        before {page.click_link "publish topic"}
        it "should have the right topic assositations" do
         Topic.last.topicdraft.should eq topicdraft
         Post.last.postable.should eq Topic.last
        end
        
         it "should have the right user assositations" do
          Topicdraft.last.user.should eq user
         end
      end 
      
      describe "updates topic values" do
        before {page.click_link "publish topic"}
         it "should create topic tags" do  
          Topic.last.tag_list.should include("tag1") 
          Topic.last.tag_list.should include("tag2")
          Topic.last.tag_list.should include("tag3")
        end
        it "draft is not ahead of published" do
          Topicdraft.last.draft_ahead.should eq false
        end

        it "should create post tags" do   
          Topic.last.posts[0].owner_tags_on(user, :tags).each_with_index do |tag, n|
            Topic.last.tag_list.should include tag.name
          end     
        end         
        it "should have the right title" do
         Topic.last.title.should eq topicdraft.title
        end
        it "should have the right summary" do
         Topic.last.summary.should eq topicdraft.summary
        end
        it "should have the right references" do
         Topic.last.reference.should eq topicdraft.reference
        end
        it "should have the right content" do
         Topic.last.content.should eq topicdraft.content
        end

      end  
    end
   
    describe "publishing a draft for an existing topic" do
     let(:post) {FactoryGirl.create(:post, user: user, postable: 
          FactoryGirl.create(:topic)) }
     let(:topicdraft ) { FactoryGirl.create(:topicdraft, topic: post.postable, user: user) } 
     
     before { visit user_topicdraft_path(user, topicdraft) }
     
     subject {page}  
          
      it "should not create a topic" do        
        expect { page.click_link "publish topic" }.to_not change(Topic, :count)
      end
      it "should notcreate a post" do
        expect { page.click_link "publish topic" }.to_not change(Post, :count)        
      end
      
      describe "updates topic values" do
        before {page.click_link "publish topic"}
        it "should have the right topic assositations" do
         Topic.last.topicdraft.should eq topicdraft
         Post.last.postable.should eq Topic.last
        end
        
         it "should have the right user assositations" do
          Topicdraft.last.user.should eq user
         end
      end 
      
      describe "updates topic values" do
        before {page.click_link "publish topic"}
         it "should create topic tags" do  
          Topic.last.tag_list.should include("tag1") 
          Topic.last.tag_list.should include("tag2")
          Topic.last.tag_list.should include("tag3")
        end
        it "draft is not ahead of published" do
          Topicdraft.last.draft_ahead.should eq false
        end

        it "should create post tags" do   
          Topic.last.posts[0].owner_tags_on(user, :tags).each_with_index do |tag, n|
            Topic.last.tag_list.should include tag.name
          end     
        end        
        it "should have the right title" do
         Topic.last.title.should eq topicdraft.title
        end
        it "should have the right summary" do
         Topic.last.summary.should eq topicdraft.summary
        end
        it "should have the right references" do
         Topic.last.reference.should eq topicdraft.reference
        end
        it "should have the right content" do
         Topic.last.content.should eq topicdraft.content
        end

      end      
    
    end    
    
  end  

  describe "topic editing" do 

    describe "for an existing topic" do
      let(:post) {FactoryGirl.create(:post, user: user, postable: 
          FactoryGirl.create(:topic)) }
      let(:topicdraft ) { FactoryGirl.create(:topicdraft, topic: post.postable, user: user) }  
      before do     
        visit edit_user_topicdraft_path(user, topicdraft)
      end
      
      subject {page}
      
      describe "shows topic info" do
        it { should have_selector('title', text: full_title(user.name + ' | edit ' + topicdraft.title)) }
        it { should have_selector('input', value: topicdraft.title) }
        it { should have_selector('input', value: topicdraft.summary) }
        it { should have_selector('input', value: topicdraft.reference) }
        it { should have_selector('input', value: topicdraft.content) }                
      end
      
      describe "save draft with invalid information" do
        before do
           page.fill_in 'Title', with: ""
           page.click_button "Save draft topic"
        end
       
        it "should not update the topic" do
          Topic.last.title.should_not eq(" ")
        end
        
        describe "error messages" do
          it { page.should have_content('error') }
        end      
      end
    
      describe "save draft with valid information" do
        before do
           page.fill_in 'Title', with: "Lorem ipsum draft"
           page.fill_in 'Summary', with: "Ipsum lorem draft"
           page.fill_in 'content_textarea', with: "Ipsum lorem draft"
           page.fill_in 'reference_textarea', with: "Ipsum lorem draft"
           page.fill_in 'Tags', with: "tag1_draft, tag2_draft, tag3_draft"
           page.click_button "Save draft topic"
        end
        it "should update the topicdraft" do        
          Topicdraft.last.title.should eq("Lorem ipsum draft")
          Topicdraft.last.summary.should eq("Ipsum lorem draft")
          Topicdraft.last.content.should eq("Ipsum lorem draft")
          Topicdraft.last.reference.should eq("Ipsum lorem draft")
          Topicdraft.last.tag_list.should include("tag1_draft") 
          Topicdraft.last.tag_list.should include("tag2_draft")
          Topicdraft.last.tag_list.should include("tag3_draft")
          Topicdraft.last.draft_ahead.should eq true                       
        end        

        it "should not update the topic" do       
          Topic.last.title.should eq("Lorem ipsum")
          Topic.last.summary.should eq("My rails topic")
          Topic.last.content.should eq ("<div>My topic content</div>")
          Topic.last.reference.should eq("<a href='http://www.google.com'>My topic reference</a>")
          Topic.last.tag_list.should include("tag1") 
          Topic.last.tag_list.should include("tag2")
          Topic.last.tag_list.should include("tag3")                       
        end     
        
        it "should not update the post" do        
          Topic.last.title.should eq(Post.last.postable.title)
          Topic.last.summary.should eq(Post.last.postable.summary)
          Topic.last.content.should eq(Post.last.postable.content)
          Topic.last.reference.should eq(Post.last.postable.reference)
          Topic.last.tags.should eq(Post.last.postable.tags)                              
        end   

      end
    end 

   describe "for a non published topic" do
      
      let(:topicdraft ) { FactoryGirl.create(:topicdraft, user: user) }  
      
      before do     
        visit edit_user_topicdraft_path(user, topicdraft)
      end
      
      subject {page}
      
      describe "shows topic info" do
        it { should have_selector('title', text: full_title(user.name + ' | edit ' + topicdraft.title)) }
        it { should have_selector('input', value: topicdraft.title) }
        it { should have_selector('input', value: topicdraft.summary) }
        it { should have_selector('input', value: topicdraft.reference) }
        it { should have_selector('input', value: topicdraft.content) }                
      end
      
      describe "save draft with invalid information" do
        before do
           page.fill_in 'Title', with: ""
           page.click_button "Save draft topic"
        end      
        
        describe "error messages" do
          it { page.should have_content('error') }
        end      
      end
    
      describe "save draft with valid information" do
        before do
           page.fill_in 'Title', with: "Lorem ipsum draft"
           page.fill_in 'Summary', with: "Ipsum lorem draft"
           page.fill_in 'content_textarea', with: "Ipsum lorem draft"
           page.fill_in 'reference_textarea', with: "Ipsum lorem draft"
           page.fill_in 'Tags', with: "tag1_draft, tag2_draft, tag3_draft"
           page.click_button "Save draft topic"
        end
        
        it "should update the topicdraft" do        
          Topicdraft.last.title.should eq("Lorem ipsum draft")
          Topicdraft.last.summary.should eq("Ipsum lorem draft")
          Topicdraft.last.content.should eq("Ipsum lorem draft")
          Topicdraft.last.reference.should eq("Ipsum lorem draft")
          Topicdraft.last.tag_list.should include("tag1_draft") 
          Topicdraft.last.tag_list.should include("tag2_draft")
          Topicdraft.last.tag_list.should include("tag3_draft")
          Topicdraft.last.draft_ahead.should eq true   
          Topicdraft.last.topic_id.should eq nil                    
        end        
  
      end
      
      
    end 
    
  end  
end
