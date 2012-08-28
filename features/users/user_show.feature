Feature: Show Users

  As a registered user of the website
  I want to see registered users listed on the users page
  so I can know who the site users are

    Scenario: I sign in and view users
      Given I am logged in
      And I should see my profile
      When I look at the list of users
      Then I should be on the user list page
      And I should see my name
