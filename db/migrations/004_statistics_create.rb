require 'sequel'

Sequel.migration do	
	change do
		create_table(:statistics) do
			primary_key :id
			foreign_key :url_id

			Fixnum :views, unique: true, :default => 0

		end
	end
end