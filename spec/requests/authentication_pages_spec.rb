require 'spec_helper'
describe "Authentication" do

  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      
      describe "in the Projects controller" do
        describe "submitting to the create action" do
          before { post projects_path }
          specify { response.should redirect_to(new_user_session_path) }
        end
        describe "submitting to the destroy action" do
          before { delete project_path(FactoryGirl.create(:project)) }
          specify { response.should redirect_to(new_user_session_path) }
        end
      end
    
    end
  end
end