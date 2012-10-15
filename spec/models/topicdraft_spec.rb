require 'spec_helper'
require 'debugger'

describe Topicdraft do
  let(:user) { FactoryGirl.create(:user) }
  
  before do
     @topicdraft = user.topicdrafts.build      
     @topicdraft.title = "Lorem ipsum"
     @topicdraft.summary = "My rails topic" 
     @topicdraft.tag_list = "tag1, tag2"  
     @topicdraft.draft_ahead = true
     @topicdraft.save!
    
  end
  
  subject { @topicdraft }
  it { should respond_to(:title) }
  it { should respond_to(:topic_id) }
  it { should respond_to(:user_id) }
  it { should respond_to(:summary) }
  it { should respond_to(:content) }
  it { should respond_to(:reference) }
  it { should respond_to(:tag_list) }
  it { should respond_to(:draft_ahead) }
  
  it "should be valid" do
    should be_valid
   end

  describe "with no user_id" do
    before { @topicdraft.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @topicdraft.content = " " }
    it { should be_valid }
  end
  
  describe "with blank reference" do
    before { @topicdraft.reference = " " }
    it { should be_valid }
  end   
  
  describe "with blank title" do
    before { @topicdraft.title = " " }
    it { should_not be_valid }
  end
  
  describe "with title that is too long" do
    before { @topicdraft.title = "a" * 31 }
    it { should_not be_valid }
  end
  
  describe "with blank summary" do
    before { @topicdraft.summary = " " }
    it { should_not be_valid }
  end
  
  describe "with summary that is too long" do
    before { @topicdraft.summary = "a" * 141 }
    it { should_not be_valid }
  end
  
  describe "with to few tags" do
    before do       
       @topicdraft.tag_list = "tag1"
       @topicdraft.save
     end
    it { should_not be_valid }
  end
end
