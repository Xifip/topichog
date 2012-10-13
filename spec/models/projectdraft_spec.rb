require 'spec_helper'
require 'debugger'

describe Projectdraft do
  let(:user) { FactoryGirl.create(:user) }
  
  before do
     @projectdraft = user.projectdrafts.build      
     @projectdraft.title = "Lorem ipsum"
     @projectdraft.summary = "My rails project" 
     @projectdraft.tag_list = "tag1, tag2"  
     @projectdraft.draft_ahead = true
     @projectdraft.save!
    
  end
  
  subject { @projectdraft }
  it { should respond_to(:title) }
  it { should respond_to(:project_id) }
  it { should respond_to(:user_id) }
  it { should respond_to(:summary) }
  it { should respond_to(:content) }
  it { should respond_to(:reference) }
  it { should respond_to(:tag_list) }
  it { should respond_to(:draft_ahead) }
  #it { should == @post.postable.projectdraft }
  #its(:project_id) { should eq(project.id) }
  
  it "should be valid" do
    should be_valid
   end

  describe "with no user_id" do
    before { @projectdraft.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @projectdraft.content = " " }
    it { should be_valid }
  end
  
  describe "with blank reference" do
    before { @projectdraft.reference = " " }
    it { should be_valid }
  end   
  
  describe "with blank title" do
    before { @projectdraft.title = " " }
    it { should_not be_valid }
  end
  
  describe "with title that is too long" do
    before { @projectdraft.title = "a" * 31 }
    it { should_not be_valid }
  end
  
  describe "with blank summary" do
    before { @projectdraft.summary = " " }
    it { should_not be_valid }
  end
  
  describe "with summary that is too long" do
    before { @projectdraft.summary = "a" * 141 }
    it { should_not be_valid }
  end
  
  describe "with to few tags" do
    before do       
       @projectdraft.tag_list = "tag1"
       @projectdraft.save
     end
    it { should_not be_valid }
  end
end
