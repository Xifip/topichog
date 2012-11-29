=begin
# trying to change the message if a user (signed up via twitter tries to sign in via regular sign in)
  Warden::Strategies.add(:check_provider) do
    def authenticate!
        #debugger 
      if params['controller'] && params['controller'] == "devise/sessions" && 
         params['action'] && params['action'] == "create" &&
         params['commit'] && params['commit'] = "Sign in" &&
         params['user'] && params['user']['email']
          #debugger
          user = User.find_by_email(params['user']['email'])
          if user && user.provider == "Twitter"
            flash.now.alert "This email is already in use with twitter sign-in. Try sign-in with twitter"
          end  
      end    
    end
  end
=end  
