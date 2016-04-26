require 'sequel'

Sequel.migration do	
  change do
    create_table(:urls) do
      primary_key	:id
      foreign_key	:owner_id, :users

      String	:full_url, unique: true, null: false
      String	:short_url, unique: true, null: false, default: ''
      String	:title, null: false
      String  :status, null: false, default: 'private'
      Integer :size
      String	:description
      DateTime	:created_at
      DateTime	:updated_at
    end
  end
end