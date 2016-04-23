require 'json'
require 'sequel'
require 'rbnacl/libsodium'
require 'base64'

# user account information
class User < Sequel::Model
  include SecureModel
  plugin :timestamps, :create=>:created_at, :update=>:updated_at, update_on_create: true
  
  # relations
  one_to_many :urls

  # associations
  plugin :association_dependencies, urls: :destroy

  # restrictions
  set_allowed_columns :email, :account_status, :username

  def password=(new_password)
    nacl = RbNaCl::Random.random_bytes(RbNaCl::PasswordHash::SCrypt::SALTBYTES)
    digest = hash_password(nacl, new_password)
    self.salt = Base64.urlsafe_encode64(nacl)
    self.password_hash = Base64.urlsafe_encode64(digest)
  end

  def password?(try_password)
    nacl = Base64.urlsafe_decode64(salt)
    try_digest = hash_password(nacl, try_password)
    try_password_hash = Base64.urlsafe_encode64(try_digest)
    try_password_hash == password_hash
  end

  def to_json(options = {})
    JSON({  type: 'user',
            id: id,
            data: {
              username: username,
              account_status: account_status,
            }
          },
          options)
  end
end