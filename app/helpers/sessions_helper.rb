module SessionsHelper
  def sign_in(user, remember_forever=false)
    #hybrid auth section, will store user id in a session variable and a remmeber token in the db if the user ticked "remember"
    #this way we can use the session variable if it's there, or populate from the db if not
    #to give us a way to have persistent and semi-persistent sessions
    remember_token = User.new_remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    if remember_forever
      #If we're to remember this user forever then store the permanent token in a cookie
      cookies.permanent[:remember_token] = remember_token      
    else
      #Otherwise we'll just store it for this session
      session[:remember_token]=remember_token
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
    if (session[:remember_token])
      @current_user||=User.find_by(remember_token: User.encrypt(session[:remember_token]))
    elsif (cookies[:remember_token])
      @current_user||=User.find_by(remember_token: User.encrypt(cookies[:remember_token]))
    end
  end
  
  #Sign out
  def sign_out
    #Replace the remember_token (we'll change this later to delete the session item)
    #Just incase someone does a nasty and restores any cookies
    if signed_in?
      remember_token = User.new_remember_token
      self.current_user.update_attribute(:remember_token, User.encrypt(remember_token))
    end
    #Remove current_user
    self.current_user=nil
    #Tidy up any session vars or cookies
    session.delete(:remember_token) if session[:remember_token]
    cookies.delete(:remember_token) if cookies[:remember_token]
  end
end
