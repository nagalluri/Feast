class UsersController < ApplicationController
	def new
		@user = User.new
		redirect_to @group_users
	end

	def show
	    @user = User.find_by(id: params[:id])
	    redirect_to group_users_path
	end

	def index
	end

	def create
	  @user = User.new(user_params)
	  @user.save
	  render :index
	end

	private
	  def user_params
	    params.require(:user).permit(:username, :group_id, :preferences)
	  end
end
