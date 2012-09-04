Feature: A signed in user can view projects
	As a signed-in use
	So that I can learn from projects
	I can see project details
	
	Scenario: A signed-in user can access project details from the home page		
		Given I am logged in
		And I have a project
		And I am on the home page
		Then I should see my project feed
		When I click title of the project
		Then I should see the project details
	
	Scenario: A signed-in user can access project details from their profile page
		Given I am logged in
		And I have a project
		And I am on my profile page
		Then I should see my project feed
		When I click title of the project
		Then I should see the project details
		
	Scenario: A signed-in user can access project details from another users profile page
		Given I am logged in
		And another user has a project
		And I am on the other users profile page
		Then I should see their project feed
		When I click title of the project
		Then I should see the project details