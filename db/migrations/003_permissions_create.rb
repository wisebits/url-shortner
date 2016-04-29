require 'sequel'

Sequel.migration do 
  change do
    #create_join_table(viewer_id: :users, url_id: :urls)
    create_table(:permissions) do
      #create_join_table(viewer_id: :users, url_id: :urls)
      #String :id, type: :uuid, primary_key: true
      foreign_key :url_id, :urls, null: false
      foreign_key :viewer_id, :users, null: false

      primary_key [:url_id, :viewer_id]
      index [:viewer_id, :url_id]

      String  :description
      DateTime  :created_at
      DateTime  :updated_at
    end
  end
end
