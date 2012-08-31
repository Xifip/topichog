Feature: Signed in user can visit following and follower pages or other users

  As a signed in user
  I can see my follower and following pages
  so I can see who are my followers and who I am following

    Scenario: I am signed in and see who I am following on my following page
      Given I am logged in
      And I am following another user
      When I visit my following page
      Then I should see my following page
      And I should see that I am following the other user

	Scenario: I am signed in and see who I am following on my following page
      Given I am logged in
      And I am following another user
      When I visit the other users followers page
      Then I should see the other users followers page
      And I should see that I am a follower of the other user