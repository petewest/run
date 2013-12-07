module SessionsHelper
  def sign_in(user, remember_forever=false)
    #hybrid auth section, will store user id in a session variable and a remmeber token in the db if the user ticked "remember"
    #this way we can use the session variable if it's there, or populate from the db if not
    #to give us a way to have persistent and semi-persistent sessions
    remember_token = User.new_remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    unless remember_forever
      session[:remember_token]=remember_token
    else
      #If we're to remember this user forever then store the permanent token in a cookie
      cookies.permanent[:remember_token] = remember_token
    end
    #use setter function 
    self.current_user= user
  end
  
  def current_user=(user)
    @current_user = user
  end
  def signed_in?
    !current_user.nil?
  end
  
  #change default getter to lookup based on either session variable or cookie
  def current_user
    if (!session[:remember_token].nil?)
      @current_user||=User.find_by(remember_token: User.encrypt(session[:remember_token]))
    elsif (!cookies[:remember_token].nil?)
      @current_user||=User.find_by(remember_token: User.encrypt(cookies[:remember_token]))
    end
  end
  
  #Sign out
end
