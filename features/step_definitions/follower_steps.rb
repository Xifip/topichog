
And /^I have followers$/ do
 create_other_user
 @other_user.follow!(@user)
end

Then /^I should see my follower stats$/ do
  page.should have_link("0 following", href: following_user_path(@user))
  page.should have_link("1 followers", href: followers_user_path(@user)) 
end