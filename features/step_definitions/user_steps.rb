require 'debugger'
include(MailerMacros)

### UTILITY METHODS ###

def create_visitor
  @visitor ||= { :name => "Testy McUserton", :email => "example@example.com",
    :password => "foobar", :password_confirmation => "foobar" }
end

def find_user
  @user ||= User.where(:email => @visitor[:email]).first
end

def create_unconfirmed_user
  create_visitor
  delete_user
  sign_up
  #visit '/users/sign_out'
  visit destroy_user_session_path
end

def create_user
  create_visitor
  delete_user
  #@user = FactoryGirl.create(:user, email: @visitor[:email])
  @user = User.create!(name: @visitor[:name], email: @visitor[:email], password: @visitor[:password], password_confirmation: @visitor[:password_confirmation])
  @user.confirm!
end

def create_other_user
  #create_visitor
  #delete_user
  #@other_user = FactoryGirl.create(:user, :name => "Following McUserton", :email => "following@example.com",
  #  :password => "foobar", :password_confirmation => "foobar")
  @other_user = User.create(:name => "Following McUserton", :email => "following@example.com",
    :password => "barfoo", :password_confirmation => "barfoo")
  @other_user.confirm!
end

def delete_user
  @user ||= User.where(:email => @visitor[:email]).first
  @user.destroy unless @user.nil?
end

def sign_up
  delete_user
  #visit '/users/sign_up'
  visit new_user_registration_path
  fill_in "Name", :with => @visitor[:name]
  fill_in "Email", :with => @visitor[:email]
  fill_in "Password", :with => @visitor[:password]
  fill_in "Password confirmation", :with => @visitor[:password_confirmation]
  click_button "Sign up"
  find_user
end

def sign_in
  #visit '/users/sign_up'
  visit new_user_session_path
  fill_in "Email", :with => @visitor[:email]
  fill_in "Password", :with => @visitor[:password]
  click_button "Sign in"
end

def current_path
  URI.parse(current_url).path
end

### GIVEN ###
Given /^I am not logged in$/ do
  #visit '/users/sign_out'
  visit destroy_user_session_path
end

Given /^I am logged in$/ do
  create_user
  sign_in
end

Given /^I exist as a user$/ do
  create_user
end

Given /^I do not exist as a user$/ do
  create_visitor
  delete_user
end

Given /^I exist as an unconfirmed user$/ do
  create_unconfirmed_user
end

### WHEN ###
When /^I sign in with valid credentials$/ do
  create_visitor
  sign_in
end

When /^I sign in with valid user data$/ do
  sign_in
end

When /^I sign out$/ do
  #visit '/users/sign_out'
  visit destroy_user_session_path
end

When /^I sign up with valid user data$/ do
  create_visitor
  sign_up
end

When /^I confirm sign up$/ do
  @user.confirm!
end

When /^I sign up with an invalid email$/ do
  create_visitor
  @visitor = @visitor.merge(:email => "notanemail")
  sign_up
end

When /^I sign up without a password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "")
  sign_up
end

When /^I sign up without a password$/ do
  create_visitor
  @visitor = @visitor.merge(:password => "")
  sign_up
end

When /^I sign up with a mismatched password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "foobar123")
  sign_up
end

When /^I return to the site$/ do
  #visit '/'
  visit root_path
end

When /^I am on the home page$/ do
  #visit '/'
  visit root_path
end

When /^I am on my profile page$/ do
  #visit '/'
  visit user_path(@user)
end

When /^I am on the other users profile page$/ do
  #visit '/'
  visit user_path(@other_user)
end

When /^I sign in with a wrong email$/ do
  @visitor = @visitor.merge(:email => "wrong@example.com")
  sign_in
end

When /^I sign in with a wrong password$/ do
  @visitor = @visitor.merge(:password => "wrongpass")
  sign_in
end

When /^I edit my account details$/ do
  click_link "Edit account"
  fill_in "Name", :with => "newname"
  fill_in "Current password", :with => @visitor[:password]
  click_button "Update"
end

When /^I click the link "View all users"$/ do  
  click_link "View all users"
end


### THEN ###


Then /^I should be signed in$/ do
  page.should have_content "Logout"
  page.should_not have_content "Sign up"
  page.should_not have_content "Login"
end
Then /^I should see the user list/ do
  page.should have_content "Users list"
end

Then /^I should be signed out$/ do
  page.should have_content "Sign up"
  page.should have_content "Login"
  page.should_not have_content "Logout"
end

Then /^I see an unconfirmed account message$/ do
  page.should have_content "You have to confirm your account before continuing."
end

Then /^I see an confirmation email sent message$/ do
  page.should have_content  "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."
end

Then /^I see a successful sign in message$/ do
  page.should have_content "Signed in successfully."
end

Then /^I should see a successful sign up message$/ do
  page.should have_content "Welcome! You have signed up successfully."
end

Then /^I should see an invalid email message$/ do
  page.should have_content "Email is invalid"
end

Then /^I should see a missing password message$/ do
  page.should have_content "Password can't be blank"
end

Then /^I should see a missing password confirmation message$/ do
  page.should have_content "Password doesn't match confirmation"
end

Then /^I should see a mismatched password message$/ do
  page.should have_content "Password doesn't match confirmation"
end

Then /^I should see a signed out message$/ do
  page.should have_content "Signed out successfully."
end

Then /^I see an invalid login message$/ do
  page.should have_content "Invalid email or password."
end

Then /^I should see an account edited message$/ do
  page.should have_content "You updated your account successfully."
end

Then /^I should see my name$/ do
  create_user
  page.should have_content @user[:name]
end

Then /^I should get a confirmation email$/ do
  last_email.from.should include("no-reply@topichog.com") 
  last_email.to.should include(@user.email) 
  last_email.subject.should eq("TopicHog confirmation instructions") 
  last_email.body.encoded.should include("You can confirm your account email through the link below:")
  last_email.body.encoded.should include("Welcome " + @user.name + "!")
  last_email.body.encoded.should have_link(@user.email, href: confirmation_url(@user, :confirmation_token => @user.confirmation_token, host: 'localhost:3000'))
end

Then /^I should see my profile$/ do
  page.should have_selector('title', text: full_title(@user.name))  
  page.should have_selector('h1', text: @user.name)
  #page.have_selector('title', text: @user.name) 
end
