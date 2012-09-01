
And /^I have followers$/ do
 create_other_user
 @other_user.follow!(@user)
end

And /^I am following another user$/ do
 create_other_user
 @user.follow!(@other_user)
end

Then /^I should see my follower stats$/ do
  page.should have_link("0 following", href: following_user_path(@user))
  page.should have_link("1 followers", href: followers_user_path(@user)) 
end

When /^I visit my following page$/ do
  visit following_user_path(@user)
end

When /^I visit the other users followers page$/ do
  visit followers_user_path(@other_user)
end

Then /^I should see my following page$/ do
  #page.should have_selector('title', text: full_title('Following'))
  page.should have_selector('h3', text: 'Following')
end

Then /^I should see the other users followers page$/ do
  #page.should have_selector('title', text: full_title('Following'))
  page.should have_selector('h3', text: 'Followers')
end

And /^I should see that I am following the other user$/ do
  page.should have_link(@other_user.name, href: user_path(@other_user))
end

And /^I should see that I am a follower of the other user$/ do
  page.should have_link(@user.name, href: user_path(@user))
end

And /^I visit the profile of a user I follow$/ do
  create_other_user
  @user.follow!(@other_user)
  visit user_path(@other_user)
end

And /^I visit the profile of a user I don't follow$/ do
  create_other_user  
  visit user_path(@other_user)
end

When /^I follow the other user$/ do
  click_button "Follow"
end 

When /^I unfollow the other user$/ do
  click_button "Unfollow"
end 

And /^the "Follow" button should change to "Unfollow"$/ do
  page.should have_selector('input', value: 'Unfollow')
end 

And /^the "Unfollow" button should change to "Follow"$/ do
  page.should have_selector('input', value: 'Follow')
end 

And /^I visit a users follower page$/ do
  create_other_user
  visit followers_user_path(@other_user)
end

And /^I visit a users following page$/ do
  create_other_user
  visit following_user_path(@other_user)
end