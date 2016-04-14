require 'sequel'

Sequel.migration do	
	change do
		create_table(:users) do
			primary_key :id

			String :email, unique: true, null: false
			String :password, unique: true, null: false
			String :account_status, unique: true, null: false
			DateTime :created_at
			DateTime :updated_at
		end
	end
end