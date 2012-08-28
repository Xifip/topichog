require 'spec_helper'
require 'debugger'

describe ApplicationController do
  controller do
    def after_sign_in_path_for(resource)        
        #user_path(resource)
        super resource
    end
  end

  before (:each) do
    @user = FactoryGirl.create(:user)
  end

  describe "After sigin-in" do
    it "redirects to the user profile page" do
        controller.after_sign_in_path_for(@user).should == user_path(@user)
    end
  end

end
