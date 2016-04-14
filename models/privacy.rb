require 'json'
require 'sequel'

# properties of a short url
class Privacy < Sequel::Model
  many_to_one :urls

  def to_json(options = {})
    JSON({  type: 'privacy',
            id: id,
            data: {
              description: password,
              status: status,
              date_created: date_created
            }
          },
          options)
  end
end