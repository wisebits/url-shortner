require 'sequel'

Sequel.migration do	
	change do
		create_table(:privacies) do
			primary_key :id
			foreign_key :url_id
			foreign_key :user_id

			String :status, unique: true, null: false
			String :description
			DateTime :date_created, unique: true, null: false
		end
	end
end