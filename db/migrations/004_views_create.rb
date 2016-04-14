require 'sequel'

Sequel.migration do	
	change do
		create_table(:views) do
			primary_key :id
			foreign_key :url_id

			#Fixnum :views, unique: true, :default => 0
			String :location, :default => ''
			String :ip_address, :default => ''

			DateTime :created_at
			DateTime :updated_at
		end
	end
end