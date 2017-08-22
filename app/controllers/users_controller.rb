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
	    @group = Group.find_by(access_token: params[:group_access_token])
	    @group_users = User.where(:group_id => @group.id)
	    @top_match = ""
	    # @group = Group.find_by(id: @user.group_id)
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
      location_id = location_details(@group.location)
      puts location_id
      cuisines = food_filter(@group.cost_filter1, @group.cost_filter2, @group.cost_filter3, @group.cost_filter4, @group.food_filter5,
	     @group.food_filter6, @group.food_filter7, @group.food_filter8, @group.food_filter9, @group.food_filter10, @group.food_filter11, @group.food_filter12)
	  restaurants1 = search(@group.rating_filter, location_id, @group.keyword, cuisines)
	  restaurants2 = search2(@group.rating_filter, location_id, @group.keyword, cuisines)
	  @restaurants = restaurants1 + restaurants2		
	  max_i = curr_match(@group_users, @restaurants)
	  puts "restaurants max_i"
	  @top_match = @restaurants[max_i]
	  puts @top_match
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

	def curr_match(array, restaurants)
		pref_list = []
		max_indexes = []
		curr_max = 0
		max_i = 0
		i = 0
		results = []
		
		for user in array
			pref_list.push(user.preferences)
		end
		sum_array = pref_list.transpose.map {|x| x.reduce(:+)}
		size = sum_array.size
		while i < size do
			if sum_array[i] > curr_max
				curr_max = sum_array[i]
				puts "loop"
				max_i = i
				max_indexes.push[i]
			end
			i = i + 1
		end
		for index in 0 ... (max_indexes.size - 1)
			results.push(restaurants[max_indexes[index]])
		end

		puts "max_indexes"
		return max_i

		# puts session[:restaurants]
	end

	def location_details(location)
	  require "uri"
	  require "json"
	  puts location
	  uri = URI.parse("https://developers.zomato.com/api/v2.1/locations" + "?" + "query=" + location)
	  puts uri
	  http = Net::HTTP.new(uri.host, uri.port)
	  http.use_ssl = true

	  request = Net::HTTP::Get.new(uri.request_uri)
	  request['user-key'] = "f320d620b609e8b9b0d36d79a4f2c85a"
	  # request.set_form_data({"location" => location, "term" => keyword})

	  response = http.request(request)      # => 301
	  puts response
	  json = JSON.parse(response.body)            # => The body (HTML, XML, blob, whatever)
	  puts json
	  return json['location_suggestions'][0]['entity_id']
	end
	
    def search(rating_filter, location, keyword, cuisines)
	  require "uri"
	  require "json"
	  uri = URI.parse("https://developers.zomato.com/api/v2.1/search" + "?" + "entity_id=" + location.to_s + "&entity_type=city" + "&cuisines=" + cuisines.to_s + "&sort=" + rating_filter)
	  puts uri
	  http = Net::HTTP.new(uri.host, uri.port)
	  http.use_ssl = true

	  request = Net::HTTP::Get.new(uri.request_uri)
	  request['user-key'] = "f320d620b609e8b9b0d36d79a4f2c85a"
	  # request.set_form_data({"location" => location, "term" => keyword})

	  response = http.request(request)      # => 301
	  json = JSON.parse(response.body)            # => The body (HTML, XML, blob, whatever)
	  puts json["results_found"]
	  return json["restaurants"]
	end

	def find(key) #path to file, and word to search for
	  zipcode_path = File.join(File.dirname(__FILE__), "../assets/zipcodes.txt")
	  File.open(zipcode_path,'r') do |file| #open file
	    file.readlines.each { |line| #read lines array
	      if line.split(',')[0] == key #match the SKU
	        return [line.split(',')[1],line.split(',')[2]] #return the Model
	      end
	    }
	  end
	end

	def search2(rating_filter, location, keyword, cuisines)
	  require "uri"
	  require "json"
	  loc_array = find(location)
	  uri = URI.parse("https://developers.zomato.com/api/v2.1/search" + "?" + "entity_id=" + location.to_s + "&entity_type=city" + "&start=20" + "&cuisines=" + cuisines.to_s + "&sort=" + rating_filter)
	  puts uri
	  http = Net::HTTP.new(uri.host, uri.port)
	  http.use_ssl = true

	  request = Net::HTTP::Get.new(uri.request_uri)
	  request['user-key'] = "f320d620b609e8b9b0d36d79a4f2c85a"
	  # request.set_form_data({"location" => location, "term" => keyword})

	  response = http.request(request)      # => 301
	  json = JSON.parse(response.body)            # => The body (HTML, XML, blob, whatever)
	  puts json["results_found"]
	  return json["restaurants"]
	end

	def find(key) #path to file, and word to search for
	  zipcode_path = File.join(File.dirname(__FILE__), "../assets/zipcodes.txt")
	  File.open(zipcode_path,'r') do |file| #open file
	    file.readlines.each { |line| #read lines array
	      if line.split(',')[0] == key #match the SKU
	        return [line.split(',')[1],line.split(',')[2]] #return the Model
	      end
	    }
	  end
	end

	def food_filter(cost_filter1, cost_filter2, cost_filter3, cost_filter4, food_filter5,
	     food_filter6, food_filter7, food_filter8, food_filter9, food_filter10, food_filter11, food_filter12)
		cuisines = ""
		if cost_filter1
			cuisines += "1,"
		end
		if cost_filter2
			cuisines += "3,"	
		end
		if cost_filter3
			cuisines += "182,"		
		end
		if cost_filter4
			cuisines += "168,"
		end
		if food_filter5
			cuisines += "25,"
		end
		if food_filter6
			cuisines += "40,"
		end
		if food_filter7
			cuisines += "148,"	
		end
		if food_filter8
			cuisines += "73,"
		end
		if food_filter9
			cuisines += "82,"
		end
		if food_filter10
			cuisines += "83,"
		end
		if food_filter11
			cuisines += "95,"
		end
		if food_filter12
			cuisines += "308,"
		end
		return cuisines
	end

	private
	  def user_params
	    params.require(:user).permit(:username, :group_id, :preferences => [])
	  end
end
