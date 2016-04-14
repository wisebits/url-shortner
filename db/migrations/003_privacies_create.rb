require 'sequel'

Sequel.migration do	
	change do
		create_table(:privacies) do
			primary_key :id
			foreign_key :url_id
			foreign_key :user_id

			String :status, unique: true, null: false
			String :description
			DateTime :created_at
			DateTime :updated_at
		end
	end
end