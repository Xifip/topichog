def create_projects
  @m1 = FactoryGirl.create(:project, user: @user, title: "Foo", summary: "football") 
  @m2 = FactoryGirl.create(:project, user: @user, title: "Bar", summary: "barley") 
end

def create_a_project
  @m3 = FactoryGirl.create(:project, user: @user, title: "Foo", summary: "football") 
end


Given /^I have projects/ do
  create_projects
end

Given /^I have a project/ do
  create_a_project
end

And /^I should see my projects$/ do
    page.should have_content(@m1.title)
    page.should have_content(@m2.title)
    page.should have_content(@user.projects.count)
end

And /^I click save the project should not be saved/ do
    expect { click_button "Submit" }.to_not change(Project, :count)
end

When /^I input invalid information for a project$/ do
    fill_in 'project_title', with: ""
    fill_in 'project_summary', with: ""
end

When /^I input valid information for a project$/ do
    fill_in 'project_title', with: "Lorem ipsum"
    fill_in 'project_summary', with: "Lorem ipsum"
end

When /^I click save the project should be saved$/ do
    expect { click_button "Submit" }.to change(Project, :count).by(1)
end

When /^I click delete the project should be deleted$/ do
    expect { click_link "delete" }.to change(Project, :count).by(-1)
end

Then /^I should get an error message$/ do
    page.should have_content('error')
end

Then /^I should see my project feed/ do
    @user.project_feed.each do |item|
      page.should have_selector("li##{item.id}", text: item.title)
    end
end