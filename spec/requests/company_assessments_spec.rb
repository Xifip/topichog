require 'spec_helper'

describe "CompanyAssessments" do
  describe "GET /company_assessments" do
    it "should have the content 'Company Assessments'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      #get company_assessments_index_path
      visit '/company_assessments'
      page.should have_content('Company Assessments')
      #response.status.should be(200)
    end
  end
end
