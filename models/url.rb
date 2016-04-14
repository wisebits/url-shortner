require 'json'
require 'openssl'
require 'sequel'
require 'base64'

# properties of a short url
class Url < Sequel::Model
  plugin :timestamps, :create=>:created_at, :update=>:updated_at

  many_to_one :users
  one_to_many :privacies
  one_to_many :views

  def to_json(options = {})
    JSON({  type: 'url',
            id: id,
            data: {
              full_url: full_url,
              title: title,
              description: description,
              short_url: short_url_creator(full_url),
            }
          },
          options)
  end

  def short_url_creator(full_url)
    "http://wise.url/"+ Base64.urlsafe_encode64(Digest::SHA256.digest(full_url))[0..6]
  end
end