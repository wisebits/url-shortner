require 'sequel'

Sequel.migration do	
  change do
    create_table(:views) do
      String :id, type: :uuid, primary_key: true
      foreign_key :url_id

      String  :location, default: ''
      String  :ip_address, default: ''

      DateTime  :created_at
      DateTime  :updated_at
    end
  end
end