require 'json'
require 'openssl'
require 'sequel'
require 'base64'

# properties of a short url
class Url < Sequel::Model
  plugin :timestamps, :create=>:created_at, :update=>:updated_at

  # relationships
  many_to_one :users
  one_to_many :permissions
  one_to_many :views

  # restrictions
  set_allowed_columns :short_url, :title, :description, :full_url

  # conversion
  def to_json(options = {})
    JSON({  type: 'url',
            id: id,
            data: {
              full_url: full_url,
              title: title,
              description: description,
              short_url: short_url,
            }
          },
          options)
  end
end