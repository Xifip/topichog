Feature: Access my projects from my profile page
  As a signed in user
  I should be see myprojects listed on my profile page
  So that I can easily manage my projects

    Scenario: A signed in user sees their projects on their profile page
      Given I exist as a user
      And I am not logged in
      When I sign in with valid credentials
      Then I should see my profile
      And I should see my projects
    
	Scenario:  A signed in user can view the details of a project
	
	Scenario:  A signed in user can edit the details of a project
	
	Scenario:  A signed in user can delete a project
	