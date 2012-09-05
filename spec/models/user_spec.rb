require 'spec_helper'
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

describe User do
  #DatabaseCleaner.clean
  before(:each) do
    @attr = { 
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end
  
  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
  end
  
  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  describe "passwords" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end
  
  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    
  end
  
  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end

  end
  describe "fields that user responds to" do 
    before do
        @user = User.new(@attr)
      end
    
    subject {@user}
    
    it { should respond_to(:name) }
    it { should respond_to(:email) }
    it { should respond_to(:projects) }
    it { should respond_to(:project_feed) }
    it { should respond_to(:topics) }
    #it { should respond_to(:topic_feed) }
    it { should respond_to(:relationships) }
    it { should respond_to(:followed_users) }
    it { should respond_to(:following?) }
    it { should respond_to(:follow!) }
  end
  
  describe "project associations" do
    before do
        @user = User.new(@attr)
        @user.save
    end
    
    let!(:older_project) do
      FactoryGirl.create(:project, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_project) do
      FactoryGirl.create(:project, user: @user, created_at: 1.hour.ago)
    end
    #let!(:users_topic) do
      #FactoryGirl.create(:topic, user: @user, created_at: 1.hour.ago)
    #end
    it "should have the right projects in the right order" do
      @user.projects.should == [newer_project, older_project]
    end
    
    it "should destroy associated projects" do
      projects = @user.projects   
      #debugger   
      @user.destroy
      projects.each do |project|
        Project.find_by_id(project.id).should be_nil
      end
    end
  
    describe "status feed" do
      #DatabaseCleaner.clean
      let(:unfollowed_project) do
        FactoryGirl.create(:project, user: FactoryGirl.create(:user, name: "unfollowed", email:"unfollowed@user.com"))
      end      
      
      let(:followed_user) { FactoryGirl.create(:user) }
      
      before do
        @user.follow! followed_user
        3.times { followed_user.projects.create!(title: "Lorem ipsum", summary: "Ipsum lorem") }
        #3.times { FactoryGirl.create(:project, user: followed_user) }
      end
      
      #let(:followed_project) { FactoryGirl.create(:project, user: @followed_user) }
      
      subject {@user}
      its(:project_feed) { should include(newer_project) }
      its(:project_feed) { should include(older_project) }
      #its(:project_feed) { should include(followed_project) }
      its(:project_feed) { should_not include(unfollowed_project) }
      its(:project_feed) do
          followed_user.projects.each do |project|
          should include(project)
        end
      end
    end
  end 
  
  describe "topic associations" do
    
    before do
        @user = User.new(@attr)
        @user.save
    end
    
    let!(:older_topic) do
      FactoryGirl.create(:topic, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_topic) do
      FactoryGirl.create(:topic, user: @user, created_at: 1.hour.ago)
    end
    
    it "should have the right topics in the right order" do
      @user.topics.should == [newer_topic, older_topic]
    end
    
    it "should destroy associated topics" do
      topics = @user.topics   
      #debugger   
      @user.destroy
      topics.each do |topic|
        Topic.find_by_id(topic.id).should be_nil
      end
    end
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user = User.new(@attr)
      @user.save
      @user.follow!(other_user)
      #debugger
      #t = 6
    end
    subject {@user}

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }
    
    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }
      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
    
    describe "others followers include user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end

  end
end
