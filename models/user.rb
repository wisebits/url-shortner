require 'json'
require 'sequel'

# properties of a short url
class User < Sequel::Model
  one_to_many :urls

  def to_json(options = {})
    JSON({  type: 'user',
            id: id,
            data: {
              email: email,
              password: password,
              account_status: account_status,
              date_created: date_created
            }
          },
          options)
  end
end