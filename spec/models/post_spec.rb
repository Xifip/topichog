require 'spec_helper'
require 'debugger'

describe Post do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:topic) {FactoryGirl.create(:topic)}
  
  before do
     @post = user.posts.build 
     @post.postable = topic
     @post.user.tag(@post, :with =>  topic.tag_list, :on => :tags)
     @post.save!
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
  it { should respond_to(:tags) }
  its(:user) { should == user }  
  its(:postable) { should == topic }
  
  it "should be valid" do
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
    
    let(:user2) { FactoryGirl.create(:user) }
    let(:user3) { FactoryGirl.create(:user) }
    
    it "should have the right number of likes" do
      user2.like!(@post)
      @post.likes_count.should == 1
      user3.like!(@post)
      @post.likes_count.should == 2
      user2.unlike!(@post)
      @post.likes_count.should == 1
    end    
    
  end

  describe "tags" do

    it { should be_valid }

    it "should have the right tags" do   
      @post.owner_tags_on(nil, :tags).each_with_index do |tag, n|
        topic.tag_list.should include tag.name
      end     
    end
    
    it "should find post when searching with it's tags" do

      Post.tagged_with(topic.tag_list[0]).should include @post
      Post.tagged_with("tails").should_not include @post
      Post.tagged_with(topic.tag_list[1]).should include @post
      Post.tagged_with(topic.tag_list[2]).should include @post
      Post.tagged_with(["baths","tails"], :exclude => true).should include @post
      Post.tagged_with([topic.tag_list[0],"tails"], any: true).should include @post
      Post.tagged_with([topic.tag_list[0],"tails"]).should_not include @post
      Post.tagged_with([topic.tag_list[0],topic.tag_list[1]]).should include @post
      Post.tagged_with([topic.tag_list[0],topic.tag_list[2]]).should include @post
      Post.tagged_with([topic.tag_list[2],topic.tag_list[1]]).should include @post
      Post.tagged_with([topic.tag_list[2],topic.tag_list[1]], match_all: true).should_not include @post
      Post.tagged_with([topic.tag_list[0],topic.tag_list[1],topic.tag_list[2]], :match_all => true).should include @post
    end
  end
end
