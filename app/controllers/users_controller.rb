class UsersController < ApplicationController
	def new
		@user = User.new
		redirect_to @group_users
	end

	def show
	    @user = User.find_by(id: params[:id])
	    @group_users = User.find(:all, :conditions => {:group_id => @user.group_id})
	    puts @group_users
	    redirect_to group_users_path
	end

	def index
	    @user = User.find_by(id: session[:id])
	    @group_users = User.find(:all, :conditions => {:group_id => @user.group_id})
	    @group = Group.find_by(id: @user.group_id)
	end

	def create
	  @user = User.new(user_params)
	  session[:id] = @user.id
	  session[:restaurants] = @user.restaurants
	  @user.restaurants = "null"
	  new_array = validate_array(@user.preferences)
	  @user.preferences = new_array
	  puts @user.preferences.length
	  @user.save
	  @group_users = User.where(:group_id => @user.group_id)
	  @group = Group.find_by(id: @user.group_id)
	  puts curr_match(@group_users)
	  render :index
	end

	def validate_array(array) 
		for index in 0 ... (array.size - 1)
			if array[index + 1] == 1
				array.delete_at(index)
			end
		end
		return array
	end

	def curr_match(array)
		pref_list = []
		for user in array
			pref_list.push(user.preferences)
		end
		sum_array = pref_list.transpose.map {|x| x.reduce(:+)}
		puts sum_array
		puts session[:restaurants]
	end

	private
	  def user_params
	    params.require(:user).permit(:username, :group_id, :preferences => [])
	  end
end
