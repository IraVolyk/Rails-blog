class UsersController < ApplicationController
  before_action :correct_user,   only: [:edit, :update, :destroy]
  skip_before_action :logged_in_user, only: [:new, :create]

  def index
  	@users = User.paginate(page: params[:page], per_page: 10)
  end

	def show
	  @user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def edit
		@user = User.find(params[:id])
	end

	def create
	  @user = User.new(user_params)
	  if @user.save
	  	log_in @user
	  	flash[:success] = "Welcome"
	    redirect_to @user
	   else
	    render 'new'
	  end
	end

	def update
		@user = User.find(params[:id])
	    if @user.update(user_params)
	    	flash[:success] = "Profile updated"
	      redirect_to @user
	    else
	      render 'edit'
	    end
	end

	def destroy
		@user = User.find(params[:id]).destroy
	flash[:success] = "User deleted"
	redirect_to users_url
	end

	private
		def user_params
			params.require(:user).permit(:avatar, :name, :email, :password, :password_confirmation)
		end

	def correct_user
	  if !current_user.admin?
	    @user = User.find(params[:id])
	    redirect_to(root_url) unless current_user?(@user)
	  end
	end

	def admin_user
	  redirect_to(root_url) unless current_user.admin?
	end
end
