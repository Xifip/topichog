Feature: See follower/ following stats on the home page
  As a signed in user
  I should be see my project feed on the home page
  So that I can easily monitor my projects

    Scenario: A signed in user sees their project feed on the home page
      Given I exist as a user
      And I am not logged in
      When I sign in with valid credentials
      And I have followers
      And I am on the home page      
      Then I should see my follower stats