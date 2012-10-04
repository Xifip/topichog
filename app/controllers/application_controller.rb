class ApplicationController < ActionController::Base
  protect_from_forgery
  def after_sign_in_path_for(resource) 
      #user_path(current_user)      
      user_path(resource)
    end
  
  protected

    def ckeditor_filebrowser_scope(options = {})
      super({ :assetable_id => current_user.id, :assetable_type => 'User' }.merge(options))
    end
end
