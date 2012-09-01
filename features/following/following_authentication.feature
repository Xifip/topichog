Feature: authentication for following and follower pages

  As a none signed in visitor to the website
  I must be signed in to see a users follower and following pages
  so that a users follower and following pages are protected

    Scenario: I am not signed in and try to view follower pages
      Given I am not logged in
      And I visit a users follower page
      Then I should be redirected to the root page

	Scenario: I am not signed in and try to view following pages
      Given I am not logged in
      And I visit a users following page
      Then I should be redirected to the root page