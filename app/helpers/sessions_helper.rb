module SessionsHelper
   def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
  
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
  
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end
  #The redirect_back_or method redirects to the requested URI if it exists, 
  #or some default URI otherwise, which we add to the Sessions controller create action 
  #to redirect after successful signin
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
#The store_location method puts the requested URI in the session variable under the key :return_to
  def store_location
    session[:return_to] = request.url
  end
end
