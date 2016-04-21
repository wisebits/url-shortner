require 'json'
require 'sequel'
require 'base64'
require_relative 'lib/encryptable_model'

# properties of a short url
class Url < Sequel::Model
  include EncryptableModel
  plugin :timestamps, :create=>:created_at, :update=>:updated_at
  
  # relationships
  many_to_one :users
  one_to_many :permissions
  one_to_many :views

  # restrictions
  set_allowed_columns :short_url, :title, :description#, :full_url

  def url=(plain_url)
    @url = plain_url
    self.full_url = encrypt(@url)
  end

  def url
    @url ||= decrypt(full_url)
  end

  # conversion
  def to_json(options = {})
    doc = url ? Base64.strict_encode64(url) : nil

    JSON({  type: 'url',
            id: id,
            data: {
              full_url: doc,
              title: title,
              description: description,
              short_url: short_url,
            }
          },
          options)
  end
end