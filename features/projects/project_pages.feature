Feature: project creation
	So that users projects are protected from deletion and creation by other users
	As a non-signed-in person
	I should not be able to create or delete user projects
	
	Scenario: A signed-in user cannot create a project with invalid information
		Given I am logged in
		And I visit the new_user_project page
		When I input invalid information for a project
		When I click save the project should not be saved		
		And I should get an error message
		
	Scenario: A signed-in user can create a project with valid information
		Given I am logged in
		And I visit the new_user_project page
		When I input valid information for a project
		When I click save the project should be saved