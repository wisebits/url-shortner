require 'json'
require 'sequel'

# properties of a short url
class Statistic < Sequel::Model
  many_to_one :urls

  def to_json(options = {})
    JSON({  type: 'statistic',
            id: id,
            data: {
              views: views
            }
          },
          options)
  end
end