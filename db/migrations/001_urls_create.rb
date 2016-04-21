require 'sequel'

Sequel.migration do	
  change do
    create_table(:urls) do
      primary_key	:id
      foreign_key		:user_id

      String	:full_url, unique: true, null: false
      String	:short_url, unique: true, null: false, default: ''
      String	:title, null: false
      String	:description
      DateTime	:created_at
      DateTime	:updated_at
    end
  end
end