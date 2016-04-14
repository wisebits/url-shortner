require 'json'
require 'sequel'

# properties of a short url
class Permission < Sequel::Model
  plugin :timestamps, :create=>:created_at, :update=>:updated_at
  many_to_one :urls

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