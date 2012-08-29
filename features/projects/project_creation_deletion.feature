Feature: Restrict access to creating and deletating projects to users not signed in
	So that users projects are protected from deletion and creation by other users
	As a non-signed-in person
	I should not be able to create or delete user projects
	
	Scenario: A non-signed-in person cannot create a project
		Give I am not logged in
		When I try to create a project
		Then I should be on the sign-in page
	
	Scenario: A non-signed-in person cannot delete a project
		Give I am not logged in
		When I try to delete a project
		Then I should be on the sign-in page