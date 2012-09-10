require 'spec_helper'
require 'debugger'

describe Post do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:topic) {FactoryGirl.create(:tpost)}
  
  before do
     @post = user.posts.build 
     @post.postable = topic
  end
  
  subject { @post }
  
  it { should respond_to(:postable) }
  it { should respond_to(:postable_id) }
  it { should respond_to(:postable_type) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }  
  its(:postable) { should == topic }
  
  it "should be valid" do
    #debugger
    should be_valid
   end
  
  describe "when user_id is not present" do
    
    before { @post.user_id = nil }
    it { should_not be_valid }
  end   
  
  describe "when postable_id is not present" do
    
    before { @post.postable_id = nil }
    it { should_not be_valid }
  end   

  describe "when postable_type is not present" do
    
    before { @post.postable_type = nil }
    it { should_not be_valid }
  end  
  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Post.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end  

end