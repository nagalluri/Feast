class Group < ApplicationRecord
	has_secure_token :access_token
	has_many :users

	 def to_param
	   access_token
	 end
end
