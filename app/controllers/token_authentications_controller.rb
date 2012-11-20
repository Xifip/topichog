# token_authentications_controller.rb

class TokenAuthenticationsController < ApplicationController 

  def create
    debugger
    @user = User.find_by_id(params[:user_id])
    @user.reset_authentication_token!
    redirect_to edit_user_registration_path(@user)
  end

  def destroy
    @user = User.find_by_idd(params[:id])
    @user.authentication_token = nil
    @user.save
    redirect_to edit_user_registration_path(@user)
  end

end

