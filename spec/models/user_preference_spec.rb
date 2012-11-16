require 'spec_helper'
require 'debugger'

describe UserPreference do
  let(:user) { FactoryGirl.create(:user) }
  
  before do
     @user_preference = user.build_user_preference
     @user_preference.save!
  end
  
  subject { @user_preference }
  
  it { should respond_to(:mail_on_liker) }
  it { should respond_to(:mail_on_follower_post) }
  it { should respond_to(:mail_on_follower) }
  it { should respond_to(:mail_monthly_update) }
  it { should respond_to(:mail_new_features) }
  its(:user) { should == user }  
end
