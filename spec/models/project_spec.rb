require 'spec_helper'
require 'debugger'

describe Project do
  
  let(:user) { FactoryGirl.create(:user) }
  
  before do
    @post = user.posts.build
    @project = Project.create!(title: "Lorem ipsum", summary: "My rails project", tag_list: "tag1, tag2") 
    @post.postable = @project
  end
  
  subject { @project }
  it { should respond_to(:title) }
  it { should respond_to(:posts) }
  it { should respond_to(:summary) }
  it { should respond_to(:content) }
  it { should respond_to(:reference) }
  it { should respond_to(:tag_list) }
  it { should respond_to(:projectdraft) }
  it { should == @post.postable }  


    
  it "should be valid" do
    should be_valid
   end

  describe "with blank content" do
    before { @project.content = " " }
    it { should be_valid }
  end
  
  describe "with blank reference" do
    before { @project.reference = " " }
    it { should be_valid }
  end   
  
  describe "with blank title" do
    before { @project.title = " " }
    it { should_not be_valid }
  end
  
  describe "with title that is too long" do
    before { @project.title = "a" * 31 }
    it { should_not be_valid }
  end
  
  describe "with blank summary" do
    before { @project.summary = " " }
    it { should_not be_valid }
  end
  
  describe "with summary that is too long" do
    before { @project.summary = "a" * 141 }
    it { should_not be_valid }
  end
  
  describe "with to few tags" do
    before do       
       @project.tag_list = "tag1"
       @project.save
     end
    it { should_not be_valid }
  end
  
end
