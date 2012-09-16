require 'spec_helper'
require 'debugger'

describe Post do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:topic) {FactoryGirl.create(:topic)}
  
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
  it { should respond_to(:likes) }
  it { should respond_to(:likers) }
  it { should respond_to(:likes_count) }
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
  
  describe "likes" do
    
    before(:each) do
      #@post = @user.posts.create(@attr)
      @user2 = Factory(:user, :email => Factory.next(:email))
      @user3 = Factory(:user, :email => Factory.next(:email))
    end
    
    it "should respond to a call to likes method" do
      @micropost.should respond_to(:likes)
    end
    
    it "should respond to a call to the likers method" do
      @micropost.should respond_to(:likers)
    end
    
    it "should respond to a call to a likes_count method" do
      @micropost.should respond_to(:likes_count)
    end
    
    it "should have the right number of likes" do
      @user2.like!(@micropost)
      @micropost.likes_count.should == 1
      @user3.like!(@micropost)
      @micropost.likes_count.should == 2
      @user2.unlike!(@micropost)
      @micropost.likes_count.should == 1
    end    
    
  end

end
