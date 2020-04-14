module SessionsHelper
  
	#places temporary cookies in the user's browser with an encrypted version of the user id
  def log_in(user)
  	session[:user_id] = user.id 
  end

  #Save user in permanent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id #permanently places encrypted user id in cookies 
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user?(user)
    user == current_user
  end

  #Return current user according to remember-token in cookie
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember,cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  #current user not nil
  def logged_in?
    current_user != nil
  end

  #Forget permanent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  #logout
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  #Save url
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
