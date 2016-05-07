require 'sequel'

Sequel.migration do	
  change do
    create_table(:users) do
      primary_key	:id
      String	:email, unique: true, null: false
      String :username, null: false, unique: true
      String	:password_hash, text: true, null: false
      String :salt, null: false
      String	:account_status
      DateTime	:created_at
      DateTime	:updated_at
    end
  end
end