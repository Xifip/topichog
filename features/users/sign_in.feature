Feature: Sign in
  In order to get access to protected sections of the site
  A user
  Should be able to sign in

    Scenario: User signs in successfully
      Given I exist as a user
      And I am not logged in
      When I sign in with valid credentials
      When I return to the site
      Then I should be signed in
      
      Scenario: User signs in successfully 2
      Given a user visits the signin page
	  And the user has an account
      And the user submits valid signin information
	  Then he should see a success message
	  And he should see a signout link
	  
	  Scenario: User signs in successfully 3      
      And I am not logged in
      When I sign in with valid credentials
      Then he should see a success message
	  And he should see a signout link

  

      