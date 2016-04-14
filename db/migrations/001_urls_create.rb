require 'sequel'

Sequel.migration do	
	change do
		create_table(:urls) do
			primary_key :id
			foreign_key :user_id

			String :full_url, unique: true, null: false
			String :short_url, unique: true, null: false
			String :title, unique: true, null: false
			String :description, unique: true, null: false
			DateTime :date_created, unique: true, null: false
		end
	end
end