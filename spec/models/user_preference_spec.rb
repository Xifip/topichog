require 'spec_helper'
require 'debugger'

describe UserPreference do
  let(:user) { FactoryGirl.create(:user) }
  
  before do
     @user_preference = user.build_user_preference
     @user_preference.save!
  end
  
  subject { @user_preference }
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        UserPreference.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
  
  describe "user_preference methods" do
    it { should respond_to(:mail_on_liker) }
    it { should respond_to(:mail_on_follower_post) }
    it { should respond_to(:mail_on_follower) }
    it { should respond_to(:mail_monthly_update) }
    it { should respond_to(:mail_new_features) }
    its(:user) { should == user }  
  end
  
  describe "when user id is not present" do
    before { @user_preference.user_id = nil }
    it { should_not be_valid }
  end
end
