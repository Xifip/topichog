class RegistrationsController < Devise::RegistrationsController
  
  def create
    #debugger
    super
    session[:omniauth] = nil unless @user.new_record?
  end
  
  def build_resource(*args)
    #debugger
      super
      if session[:omniauth]
        @user.name = session[:omniauth][:info][:name]
        @user.apply_omniauth(session[:omniauth])
        @user.valid?
      end
  end
    
end
