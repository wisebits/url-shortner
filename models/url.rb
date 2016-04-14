require 'json'
require 'openssl'
require 'sequel'
require 'base64'

# properties of a short url
class Url < Sequel::Model
  many_to_one :users
  onet_to_many :privacies

  def to_json(options = {})
    JSON({  type: 'url',
            id: id,
            data: {
              link: link,
              title: title,
              description: description,
              short_url: short_url,
            }
          },
          options)
  end
end
