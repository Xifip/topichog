
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
