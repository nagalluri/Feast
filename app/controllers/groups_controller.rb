class GroupsController < ApplicationController
	def new
		@group = Group.new
	end

	def show
	    @group = Group.find_by id: params[:id]
	end
	
	def create
	  @group = Group.new(group_params)
	  @group.access_token = Group.generate_unique_secure_token
	  @group.save
	  redirect_to @group
	end
	 
	private
	  def group_params
	    params.require(:group).permit(:group_name, :rating_filter, :keyword, :location, :access_token, :radius, :cost_filter1, :cost_filter2, :cost_filter3, :cost_filter4)
	  end
end
