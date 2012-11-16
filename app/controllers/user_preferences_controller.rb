class UserPreferencesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user
  
  def create
    debugger
  end
  

  private
  
  def correct_user
    @userpreference = UserPreference.find_by_id(params[:id])
    @user = @userpreference.user
    redirect_to root_path if @user != current_user
  end
end  
