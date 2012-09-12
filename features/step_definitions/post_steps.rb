def create_projects
  @m1 = FactoryGirl.create(:post, user: @user, postable: FactoryGirl.create(:project, title: "Foo", summary: "football") ) 
  @m2 = FactoryGirl.create(:post, user: @user, postable: FactoryGirl.create(:project, title: "Bar", summary: "barley")) 
end

def create_a_project
  @m3 = FactoryGirl.create(:post, user: @user, postable: FactoryGirl.create(:project, title: "hand", summary: "ball")) 
end

def create_others_project
  @m3 = FactoryGirl.create(:post, user: @other_user, postable: FactoryGirl.create(:project, title: "table", summary: "tennis")) 
end

Given /^I have projects/ do
  create_projects
end

Given /^I have a project/ do
  create_a_project
end

And /^I should see my projects$/ do
    page.should have_content(@m1.postable.title)
    page.should have_content(@m2.postable.title)
    page.should have_content(@user.posts.count)
end

And /^I click save the project should not be saved/ do
    expect { click_button "Submit" }.to_not change(Project, :count)
end

And /^another user has a project$/ do
  create_other_user
  create_others_project
end

And /^I visit the new_user_project page$/ do
  
  visit new_user_project_path(@user)
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

When /^I click title of the project$/ do  
    click_link "project_link_#{@m3.id}"
end

Then /^I should see the project details$/ do
  page.should have_content "Project details page" 
  page.should have_content "#{@m3.postable.title}"
  #page.should have_selector("h3", "Project details page") 
  #page.should have_selector("h1", "#{@m3.title}")
end

Then /^I should get an error message$/ do
    page.should have_content('error')
end

Then /^I should see my project feed/ do
    @user.project_feed.each do |item|
      page.should have_selector("li##{item.id}", text: item.postable.title)
    end
end

Then /^I should see their project feed$/ do
  @other_user.project_feed.each do |item|
      page.should have_selector("li##{item.id}", text: item.postable.title)
    end
end
