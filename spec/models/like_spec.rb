require 'spec_helper'

describe Like do
  let(:liker) { FactoryGirl.create(:user, name:"user1", email: "user1@factorygirl.com") }
  let(:liked) { FactoryGirl.create(:post, postable: FactoryGirl.create(:topic, title: "Foo", summary: "football"))}
  let(:like) { liker.likes.build(liked_id: liked.id) }
  
  subject { like }
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to liker_id" do
      expect do
        Like.new(liker_id: liker.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
  
  describe "liker methods" do
    it { should respond_to(:liker) }
    it { should respond_to(:liked) }
    its(:liker) { should == liker }
    its(:liked) { should == liked }
  end
  
  describe "when liked id is not present" do
    before { like.liked_id = nil }
    it { should_not be_valid }
  end
  describe "when liker id is not present" do
    before { like.liker_id = nil }
    it { should_not be_valid }
  end

end
