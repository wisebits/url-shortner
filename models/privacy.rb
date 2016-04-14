require 'json'
require 'sequel'

# properties of a short url
class Privacy < Sequel::Model
  plugin :timestamps, :create=>:created_at, :update=>:updated_at
  many_to_one :urls

  def to_json(options = {})
    JSON({  type: 'privacy',
            id: id,
            data: {
              description: password,
              status: status,
            }
          },
          options)
  end
end