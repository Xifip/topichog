require 'spec_helper'
require 'debugger'
describe UsersController do

  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET 'show'" do
    
    it "should be successful" do
      get :show, :id => @user.id
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user.id
      assigns(:user).should == @user
    end
    
  end
  
  describe "GET 'index'" do
  it "populates an list of users" do
      
      User.stub(:all).and_return(@user)
      get :index       
      assigns(:users).should == @user      
    end
  end  

end