Feature: Follow/Unfollow button

  As signed in user
  I can follow and unfollow other users with the follow/unfollow button
  so I can control who I follow

    Scenario: I sign in and I follow a user
      Given I am logged in      
      And I visit the profile of a user I don't follow
      When I follow the other user 
      Then the "Follow" button should change to "Unfollow"

	Scenario: I sign in and I unfollow a user
	  Given I am logged in
	  And I visit the profile of a user I follow
	  When I unfollow the other user
      Then the "Unfollow" button should change to "Follow"
	 
