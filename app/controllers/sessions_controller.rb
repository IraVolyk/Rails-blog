class SessionsController < ApplicationController
  skip_before_action :logged_in_user, only: [:new, :create]
  
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase) # find user in DB by email
  	if user && user.authenticate(params[:session][:password]) # if user finded and password correct do next
  		if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
  	  else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
     else   
  		flash[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path 
  end
end
