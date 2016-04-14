require 'sequel'

Sequel.migration do	
	change do
		create_table(:urls) do
			primary_key :id
			foreign_key :user_id

			Sequel::Model.plugin :timestamps

			String :full_url, unique: true, null: false
			String :short_url, unique: true, null: false, default: ''
			String :title, unique: true, null: false
			String :description, unique: true, null: false
			DateTime :created_at
			DateTime :updated_at
		end
	end
end