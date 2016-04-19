require 'json'
require 'sequel'

# properties of a short url
class User < Sequel::Model
  plugin :timestamps, :create=>:created_at, :update=>:updated_at
  
  # relations
  one_to_many :urls

  # restrictions
  set_allowed_columns :email, :account_status

  def to_json(options = {})
    JSON({  type: 'user',
            id: id,
            data: {
              email: email,
              password: password,
              account_status: account_status,
            }
          },
          options)
  end
end