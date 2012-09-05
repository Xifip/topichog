require 'spec_helper'
require 'debugger'

describe Project do
  
  let(:user) { FactoryGirl.create(:user) }
  
  before { @project = user.projects.build(title: "Lorem ipsum", summary: "My rails project") }
  
  subject { @project }
  it { should respond_to(:title) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }
  
  it "should be valid" do
    #debugger
    should be_valid
   end
  
  describe "when user_id is not present" do
    
    before { @project.user_id = nil }
    it { should_not be_valid }
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

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        #debugger
        Project.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
  describe "when user_id is not present" do
    before { @project.user_id = nil }
    it { should_not be_valid }
  end
end