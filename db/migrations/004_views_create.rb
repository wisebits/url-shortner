require 'sequel'

Sequel.migration do	
	change do
		create_table(:views) do
			primary_key :id
			foreign_key :url_id
			#foreign_key :user_id # might only be needed if we want to keep track of the user (not too important for analytics)

			#Fixnum :views, unique: true, :default => 0
			String :location, :default => ''
			String :ip_address, :default => ''

			DateTime :created_at
			DateTime :updated_at
		end
	end
end