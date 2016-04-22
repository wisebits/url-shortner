require 'sequel'

Sequel.migration do	
  change do
    create_table(:permissions) do
      String :id, type: :uuid, primary_key: true
      foreign_key		:url_id

      String	:status, unique: true, null: false
      String	:description
      DateTime	:created_at
      DateTime	:updated_at
    end
  end
end