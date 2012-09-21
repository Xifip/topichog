require 'spec_helper'
require 'debugger'

describe Topic do
  
  let(:user) { FactoryGirl.create(:user) }
  
  before do
    @post = user.posts.build
    @topic = Topic.create!(title: "Lorem ipsum", summary: "My rails project") 
    @topic.tag_list = "tag1, tag2"
    debugger
    @post.postable = @topic
  end
  
  subject { @topic }
  it { should respond_to(:title) }
  it { should respond_to(:posts) }
  it { should == @post.postable }
  
  it "should be valid" do
    should be_valid
   end
  
  describe "with blank title" do
    before { @topic.title = " " }
    it { should_not be_valid }
  end
  
  describe "with title that is too long" do
    before { @topic.title = "a" * 31 }
    it { should_not be_valid }
  end
  
  describe "with blank summary" do
    before { @topic.summary = " " }
    it { should_not be_valid }
  end
  
  describe "with summary that is too long" do
    before { @topic.summary = "a" * 141 }
    it { should_not be_valid }
  end
  
end
