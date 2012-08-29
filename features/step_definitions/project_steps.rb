def create_projects
  @m1 = FactoryGirl.create(:project, user: @user, title: "Foo", summary: "football") 
  @m2 = FactoryGirl.create(:project, user: @user, title: "Bar", summary: "barley") 
end

Given /^I have projects/ do
  create_projects
end

And /^I should see my projects$/ do
    page.should have_content(@m1.title)
    page.should have_content(@m2.title)
    page.should have_content(@user.projects.count)
end