require 'sequel'

Sequel.migration do	
  change do
    create_table(:base_users) do
      primary_key :id
      String :type
      String :email, unique: true, null: false
      String :username, null: false
      String :password_hash
      String :salt
      String :account_status
      DateTime :created_at
      DateTime :updated_at

      unique [:type, :username]
    end
  end
end