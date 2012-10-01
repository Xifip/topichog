require 'spec_helper'
include Warden::Test::Helpers

module RequestHelpers
  def create_logged_in_user
    #user = Factory(:user)
    user = User.create(name: 'testy', email: 'testy@example.com', password: 'password', password_confirmation: 'password')
    user.confirm!
    login(user)
    user
  end
 
  def login(user)
    login_as user, scope: :user
  end
  
#  def create_logged_in_user_name_email (name, email)
#    user = Factory(:user)
#    login(user)
#    user
#  end
end
