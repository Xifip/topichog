require 'spec_helper'
require 'debugger'

describe Profile do

  let(:user) { FactoryGirl.create(:user) }

  before do
#    @profile = user.build_profile(bio: "Lorem ipsum")
    @profile = user.profile
  end
  
  subject { @profile }

  it { should respond_to(:image) }
  it { should respond_to(:bio) }
  it { should respond_to(:user_id) }
  it { should respond_to(:linkedin_url) }
  it { should respond_to(:twitter_url) }
  it { should respond_to(:facebook_url) }
  it { should respond_to(:mysite_url) }
  it { should respond_to(:myblog_url) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it "should be valid" do
    should be_valid
  end

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Profile.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end  
  
  describe "with invalid information" do
    describe "with bio that is too long" do
      before { @profile.bio = "a" * 1001 }
      it { should_not be_valid }
    end
    
    describe "when user_id is not present" do    
      before { @profile.user_id = nil }
      it { should_not be_valid }
    end

    describe "when linkedin url is not valid" do    
      before { @profile.linkedin_url = "http:\\ww.linkedin.com" }
      it { should_not be_valid }
    end
    
    describe "when twitter url is not valid" do    
      before { @profile.twitter_url = "http:\\ww.linkedin.com" }
      it { should_not be_valid }
    end
     describe "when facebook_url is not valid" do    
      before { @profile.facebook_url = "http:\\ww.linkedin.com" }
      it { should_not be_valid }
    end
     describe "when mysite_url is not valid" do    
      before { @profile.mysite_url = "http:\\ww.linkedin.com" }
      it { should_not be_valid }
    end
    describe "when myblog_url is not valid" do    
      before { @profile.myblog_url = "http:\\ww.linkedin.com" }
      it { should_not be_valid }
    end
  end
  
  describe "with valid information" do
    describe "with bio that is not too long" do
      before { @profile.bio = "a" * 999 }
      it { should be_valid }
    end  

    describe "when linkedin url is valid" do    
      before { @profile.linkedin_url = "http:\\www.linkedin.com" }
      it { should be_valid }
    end
    
    describe "when twitter url is valid" do    
      before { @profile.twitter_url = "http:\\www.linkedin.com" }
      it { should be_valid }
    end
     describe "when facebook_url is valid" do    
      before { @profile.facebook_url = "https:\\www.linkedin.com" }
      it { should be_valid }
    end
     describe "when mysite_url is valid" do    
      before { @profile.mysite_url = "https:\\www.linkedin.com" }
      it { should be_valid }
    end
    describe "when myblog_url is valid" do    
      before { @profile.myblog_url = "https:\\www.linkedin.com" }
      it { should be_valid }
    end
  end
end
