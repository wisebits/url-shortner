require 'json'
require 'sequel'
require 'base64'
require 'openssl'

# properties of a short url
class Url < Sequel::Model
  plugin :timestamps, :create=>:created_at, :update=>:updated_at

  # relationships
  one_to_many :views
  many_to_one :owner, class: :User
  many_to_many :base_users, class: :User, join_table: :permissions, left_key: :url_id, right_key: :viewer_id 

  # dependencies cleanup
  #plugin :association_dependencies, :permissions => :delete
  plugin :association_dependencies, :views => :delete

  # restrictions
  set_allowed_columns :short_url, :title, :description#, :full_url

  # generate the short url
  def shorturl=(full_url)
    self.short_url = "http://wise.url/"+ Base64.urlsafe_encode64(Digest::SHA256.digest(url))[0..6]
  end

  def url=(plain_url)
    self.full_url = SecureDB.encrypt(plain_url) if plain_url
  end

  def url
    SecureDB.decrypt(full_url)
  end

  # conversion
  def to_json(options = {})
    full_url_final = url ? Base64.strict_encode64(url) : nil

    JSON({  type: 'url',
            id: id,
            data: {
              full_url: full_url_final,
              title: title,
              description: description,
              short_url: short_url,
            }
          },
          options)
  end
end