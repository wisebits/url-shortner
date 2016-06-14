require 'json'
require 'sequel'

# properties of a short url
class View < Sequel::Model
  plugin :timestamps, :create=>:created_at, :update=>:updated_at
  plugin :uuid, field: :id

  # relations
  many_to_one :urls

  # restriction

  def to_json(options = {})
    JSON({  type: 'view',
            id: id,
            data: {
              location: location,
              ip_address: ip_address,
              created_at: created_at
            }
          },
          options)
  end
end