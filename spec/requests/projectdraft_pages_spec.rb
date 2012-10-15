require 'spec_helper'
describe "Projectdraft pages" do
  let(:user) { create_logged_in_user } 
  
  describe "projectdraft creation" do
    before { visit new_user_projectdraft_path(user) }
    
    subject {page}
    
    describe "shows user info" do
      it { should have_selector('title', text: full_title(user.name + ' | new project draft')) }
      it { should have_selector('h1', text: user.name) }
    end
    
    describe "with invalid information" do
      it {page.should have_content "#{user.name}"}
      it {page.should have_content "New Project"}
     
      it "should not create a project" do
        expect { page.click_button "Save draft project" }.to_not change(Projectdraft, :count)
        expect { page.click_button "Save draft project" }.to_not change(Post, :count)
        expect { page.click_button "Save draft project" }.to_not change(Project, :count)
      end
      
      describe "error messages" do
        before { page.click_button "Save draft project" }
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
      it "should create a projectdraft" do        
        expect { page.click_button "Save draft project" }.to change(Projectdraft, :count).by(1)
      end
      it "should not create a project" do        
        expect { page.click_button "Save draft project" }.to_not change(Project, :count).by(1)
      end
      it "should not create a post" do
        expect { page.click_button "Save draft project" }.to_not change(Post, :count).by(1)        
      end
      
      describe "associations created" do
       
       before { page.click_button "Save draft project" }
      
       it "should have the right user assositations" do
        Projectdraft.last.user.should eq user
       end
             
      end
      describe "draft status" do
        before {page.click_button "Save draft project"}
        it "draft is ahead of published" do
          Projectdraft.last.draft_ahead.should eq true 
        end
      end
      
      describe "tag creation" do
        before {page.click_button "Save draft project"}
         it "should create project tags" do            
          Projectdraft.last.tag_list.should include("tag1") 
          Projectdraft.last.tag_list.should include("tag2")
          Projectdraft.last.tag_list.should include("tag3")
        end
      end  
    end
  end
  
  
  describe "viewing own projectdraft" do
   
    let(:projectdraft ) { FactoryGirl.create(:projectdraft, title: "Foo", summary: "football", user: user) }
  
    before { visit user_projectdraft_path(user, projectdraft) }  
    subject {page} 
    
    describe "shows user and project info" do
      it { should have_selector('h1', text: user.name) }
      it { should have_content ( projectdraft.title) }
      it { should have_content ( projectdraft.summary) }
      #user nokogiri or elementor to scrap content  
      it { should have_content ( 'My project reference') }
      it { should have_content ( 'My project content') }
      it { should have_link('view profile', href: user_path(user)) }
      it { should have_link('edit draft project', href: edit_user_projectdraft_path(user, projectdraft)) }
      it { should have_link('publish project', href: publish_user_projectdraft_path(user, projectdraft)) }      
      it { should have_link('My project reference', href: 'http://www.google.com') }
    end
    
    
  end
=begin
  describe "viewing another users project" do
    let(:other_user) { FactoryGirl.create(:user) }
    let(:post ) { FactoryGirl.create(:post, user: other_user, postable: 
    FactoryGirl.create(:project, title: "Foo", summary: "football"))  }
    #before { visit user_project_path(other_user, post.postable) }    
    before { visit user_project_path(other_user, post) }
    subject {page} 
    
    describe "shows user and project info" do
      it { should have_selector('h1', text: other_user.name) }
      it { should have_content ( post.postable.title) }
      it { should have_content ( post.postable.summary) }
      #user nokogiri or elementor to scrap content  
      it { should have_content ( 'My project reference') }
      it { should have_content ( 'My project content') }
      it { should have_link('view profile', href: user_path(other_user)) }
      it { should_not have_link('edit project', href: edit_user_project_path(user, post.postable)) }
      it { should have_link('My project reference', href: 'http://www.google.com') }
    end
    
    
  end  
=end  

  describe "projectdraft publication" do

    describe "publishing a draft for a new project" do
    
    let(:projectdraft ) { FactoryGirl.create(:projectdraft, title: "Foo", summary: "football", user: user) }  
    before { visit user_projectdraft_path(user, projectdraft) }
    
    subject {page}      

      it "should create a project" do        
        expect { page.click_link "publish project" }.to change(Project, :count).by(1)
      end
      it "should create a post" do
        expect { page.click_link "publish project" }.to change(Post, :count).by(1)        
      end
      
      describe "updates project values" do
        before {page.click_link "publish project"}
        it "should have the right project assositations" do
         Project.last.projectdraft.should eq projectdraft
         Post.last.postable.should eq Project.last
        end
        
         it "should have the right user assositations" do
          Projectdraft.last.user.should eq user
         end
      end 
      
      describe "updates project values" do
        before {page.click_link "publish project"}
         it "should create project tags" do  
          Project.last.tag_list.should include("tag1") 
          Project.last.tag_list.should include("tag2")
          Project.last.tag_list.should include("tag3")
        end
        it "draft is not ahead of published" do
          Projectdraft.last.draft_ahead.should eq false
        end

        it "should create post tags" do   
          Project.last.posts[0].owner_tags_on(user, :tags).each_with_index do |tag, n|
            Project.last.tag_list.should include tag.name
          end     
        end         
        it "should have the right title" do
         Project.last.title.should eq projectdraft.title
        end
        it "should have the right summary" do
         Project.last.summary.should eq projectdraft.summary
        end
        it "should have the right references" do
         Project.last.reference.should eq projectdraft.reference
        end
        it "should have the right content" do
         Project.last.content.should eq projectdraft.content
        end

      end  
    end
   
    describe "publishing a draft for an existing project" do
     let(:post) {FactoryGirl.create(:post, user: user, postable: 
          FactoryGirl.create(:project)) }
     let(:projectdraft ) { FactoryGirl.create(:projectdraft, project: post.postable, user: user) } 
     
     before { visit user_projectdraft_path(user, projectdraft) }
     
     subject {page}  
          
      it "should not create a project" do        
        expect { page.click_link "publish project" }.to_not change(Project, :count)
      end
      it "should notcreate a post" do
        expect { page.click_link "publish project" }.to_not change(Post, :count)        
      end
      
      describe "updates project values" do
        before {page.click_link "publish project"}
        it "should have the right project assositations" do
         Project.last.projectdraft.should eq projectdraft
         Post.last.postable.should eq Project.last
        end
        
         it "should have the right user assositations" do
          Projectdraft.last.user.should eq user
         end
      end 
      
      describe "updates project values" do
        before {page.click_link "publish project"}
         it "should create project tags" do  
          Project.last.tag_list.should include("tag1") 
          Project.last.tag_list.should include("tag2")
          Project.last.tag_list.should include("tag3")
        end
        it "draft is not ahead of published" do
          Projectdraft.last.draft_ahead.should eq false
        end

        it "should create post tags" do   
          Project.last.posts[0].owner_tags_on(user, :tags).each_with_index do |tag, n|
            Project.last.tag_list.should include tag.name
          end     
        end        
        it "should have the right title" do
         Project.last.title.should eq projectdraft.title
        end
        it "should have the right summary" do
         Project.last.summary.should eq projectdraft.summary
        end
        it "should have the right references" do
         Project.last.reference.should eq projectdraft.reference
        end
        it "should have the right content" do
         Project.last.content.should eq projectdraft.content
        end

      end      
    
    end    
    
  end  

  describe "project editing" do 

    describe "for an existing project" do
      let(:post) {FactoryGirl.create(:post, user: user, postable: 
          FactoryGirl.create(:project)) }
      let(:projectdraft ) { FactoryGirl.create(:projectdraft, project: post.postable, user: user) }  
      before do     
        visit edit_user_projectdraft_path(user, projectdraft)
      end
      
      subject {page}
      
      describe "shows project info" do
        it { should have_selector('title', text: full_title(user.name + ' | edit ' + projectdraft.title)) }
        it { should have_selector('input', value: projectdraft.title) }
        it { should have_selector('input', value: projectdraft.summary) }
        it { should have_selector('input', value: projectdraft.reference) }
        it { should have_selector('input', value: projectdraft.content) }                
      end
      
      describe "save draft with invalid information" do
        before do
           page.fill_in 'Title', with: ""
           page.click_button "Save draft project"
        end
       
        it "should not update the project" do
          Project.last.title.should_not eq(" ")
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
           page.click_button "Save draft project"
        end
        it "should update the projectdraft" do        
          Projectdraft.last.title.should eq("Lorem ipsum draft")
          Projectdraft.last.summary.should eq("Ipsum lorem draft")
          Projectdraft.last.content.should eq("Ipsum lorem draft")
          Projectdraft.last.reference.should eq("Ipsum lorem draft")
          Projectdraft.last.tag_list.should include("tag1_draft") 
          Projectdraft.last.tag_list.should include("tag2_draft")
          Projectdraft.last.tag_list.should include("tag3_draft")
          Projectdraft.last.draft_ahead.should eq true                       
        end        

        it "should not update the project" do       
          Project.last.title.should eq("Lorem ipsum")
          Project.last.summary.should eq("My rails project")
          Project.last.content.should eq ("<div>My project content</div>")
          Project.last.reference.should eq("<a href='http://www.google.com'>My project reference</a>")
          Project.last.tag_list.should include("tag1") 
          Project.last.tag_list.should include("tag2")
          Project.last.tag_list.should include("tag3")                       
        end     
        
        it "should not update the post" do        
          Project.last.title.should eq(Post.last.postable.title)
          Project.last.summary.should eq(Post.last.postable.summary)
          Project.last.content.should eq(Post.last.postable.content)
          Project.last.reference.should eq(Post.last.postable.reference)
          Project.last.tags.should eq(Post.last.postable.tags)                              
        end   

      end
    end 

   describe "for a non published project" do
      
      let(:projectdraft ) { FactoryGirl.create(:projectdraft, user: user) }  
      
      before do     
        visit edit_user_projectdraft_path(user, projectdraft)
      end
      
      subject {page}
      
      describe "shows project info" do
        it { should have_selector('title', text: full_title(user.name + ' | edit ' + projectdraft.title)) }
        it { should have_selector('input', value: projectdraft.title) }
        it { should have_selector('input', value: projectdraft.summary) }
        it { should have_selector('input', value: projectdraft.reference) }
        it { should have_selector('input', value: projectdraft.content) }                
      end
      
      describe "save draft with invalid information" do
        before do
           page.fill_in 'Title', with: ""
           page.click_button "Save draft project"
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
           page.click_button "Save draft project"
        end
        
        it "should update the projectdraft" do        
          Projectdraft.last.title.should eq("Lorem ipsum draft")
          Projectdraft.last.summary.should eq("Ipsum lorem draft")
          Projectdraft.last.content.should eq("Ipsum lorem draft")
          Projectdraft.last.reference.should eq("Ipsum lorem draft")
          Projectdraft.last.tag_list.should include("tag1_draft") 
          Projectdraft.last.tag_list.should include("tag2_draft")
          Projectdraft.last.tag_list.should include("tag3_draft")
          Projectdraft.last.draft_ahead.should eq true   
          Projectdraft.last.project_id.should eq nil                    
        end        
  
      end
      
      
    end 
    
  end  
end
