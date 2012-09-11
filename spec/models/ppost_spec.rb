require 'spec_helper'
require 'debugger'

describe Ppost do
  
  let(:user) { FactoryGirl.create(:user) }
  
  before do
    @post = user.posts.build
    @project = Ppost.create!(title: "Lorem ipsum", summary: "My rails project") 
    @post.postable = @project
  end
  
  subject { @project }
  it { should respond_to(:title) }
  it { should respond_to(:posts) }
  it { should == @post.postable }
  
  it "should be valid" do
    should be_valid
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
  
end