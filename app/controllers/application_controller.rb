class ApplicationController < ActionController::Base
	before_action :logged_in_user

	#security token
	protect_from_forgery with: :exception
  include SessionsHelper

	private
  def logged_in_user
      unless logged_in?
      	store_location
        flash[:danger] = "Please log in."
        redirect_to sessions_new_url
      end
    end
end
