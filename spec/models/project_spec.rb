require 'spec_helper'
require 'debugger'

describe Project do
  
  let(:user) { FactoryGirl.create(:user) }
  
  before do
    @post = user.posts.build
    @project = Project.create!(title: "Lorem ipsum", 
      summary: "My rails project", tag_list: "tag1, tag2") 
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
  it { should_not respond_to(:user_id) }  
  it { should == @post.postable }  
    
  it "should be valid" do
    should be_valid
   end
   
end
