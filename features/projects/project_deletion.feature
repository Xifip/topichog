Feature: A signed in user can delete their projects
	As a signed-in use
	So that I can manage my projects
	I am be able to delete my projects
	
	Scenario: A signed-in user can delete a project from the home page		
		Given I am logged in
		And I have a project
		And I am on the home page
		Then I should see my project feed
		When I click delete the project should be deleted
	
	Scenario: A signed-in user can delete a project from the profile page
		Given I am logged in
		And I have a project
		And I am on my profile page
		When I click delete the project should be deleted