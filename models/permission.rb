require 'json'
require 'sequel'

# properties of a short url
class Permission < Sequel::Model
  plugin :timestamps, :create=>:created_at, :update=>:updated_at
  #plugin :uuid, :field => :id
  
  # relations
  #many_to_one :urls, class: :Url, key: :url_id
  #many_to_one :users, class: :User, key: :user_id

  # restrictions
  set_allowed_columns :status, :description

  # conversion
  def to_json(options = {})
    JSON({  type: 'permission',
            id: id,
            data: {
              description: description,
              status: status,
            }
          },
          options)
  end
end