class GroupsController < ApplicationController
	def new
		@group = Group.new
	end

	def show
	    @group = Group.find_by(access_token: params[:access_token])
	    # yelp_authentication = post_test
	    @user = User.new
	    @restaurants = search(@group.rating_filter, @group.location, @group.keyword, @group.cost_filter1, @group.cost_filter2, @group.cost_filter3, @group.cost_filter4)
		# redirect_to @group
	end
	
	def update
		@group = Group.find_by(access_token: params[:access_token])
		@group.update(group_params)
		redirect_to @group
	end
	def create
	  
	  @group = Group.new(group_params)
	  @group.access_token = Group.generate_unique_secure_token
	  
	  @group.save
	  # yelp_authentication = post_test
	  @restaurants = search(@group.rating_filter, @group.location, @group.keyword, @group.cost_filter1, @group.cost_filter2, @group.cost_filter3, @group.cost_filter4)
	  redirect_to @group
	end

	def post_test
	  require "net/http"
	  require "uri"
	  require "json"

	  uri = URI.parse("https://api.yelp.com/oauth2/token")
	  http = Net::HTTP.new(uri.host, uri.port)
	  http.use_ssl = true

	  request = Net::HTTP::Post.new(uri.request_uri)
	  request.set_form_data({"grant_type" => "client_credentials", "client_id" => "dlt4NV99HjNhNu3nhTPoTg", "client_secret" => "n6mERsDSP06jdyARXTOoOm1h66JcK2WX9oeDsxZ8GL7iSJ4NohTVsHEgDW8HeFC3"})

	  response = http.request(request)
	  #puts response.body        # => 301
	  json = JSON.parse(response.body) 
	  array = [json]           # => The body (HTML, XML, blob, whatever)
	  # p "this is the response"
	  return [json["access_token"], json["token_type"], json["expires_in"]]
	end
	
    def search(rating_filter, location, keyword, cost_filter1, cost_filter2, cost_filter3, cost_filter4)
	  require "uri"
	  require "json"
	  loc_array = find(location)
	  uri = URI.parse("https://developers.zomato.com/api/v2.1/search" + "?" + "q=" + keyword + "&lat=" + loc_array[0] + "&lon=" + loc_array[1])
	  puts uri
	  http = Net::HTTP.new(uri.host, uri.port)
	  http.use_ssl = true

	  request = Net::HTTP::Get.new(uri.request_uri)
	  request['user-key'] = "f320d620b609e8b9b0d36d79a4f2c85a"
	  # request.set_form_data({"location" => location, "term" => keyword})

	  response = http.request(request)      # => 301
	  json = JSON.parse(response.body)            # => The body (HTML, XML, blob, whatever)
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

	private
	  def group_params
	    params.require(:group).permit(:group_name, :rating_filter, :keyword, :location, :access_token, :radius, :cost_filter1, :cost_filter2, :cost_filter3, :cost_filter4, :users)
	  end
end
