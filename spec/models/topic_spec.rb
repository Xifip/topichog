require 'spec_helper'
require 'debugger'

describe Topic do
  
  let(:user) { FactoryGirl.create(:user) }
  
  before { @topic = user.topics.build(title: "Lorem ipsum", summary: "My rails topic") }
  
  subject { @topic }
  it { should respond_to(:title) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }
  
  it "should be valid" do
    #debugger
    should be_valid
   end
  
  describe "when user_id is not present" do
    
    before { @topic.user_id = nil }
    it { should_not be_valid }
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

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        #debugger
        Topic.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end  

end