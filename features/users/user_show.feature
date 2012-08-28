Feature: Show Users

  As a registered user of the website
  I want to see registered users listed on the users page
  so I can know who the site users are

    Scenario: I sign in and view users
      Given I am logged in
      When I look at the list of users
      Then I should see my name
