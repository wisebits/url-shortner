require 'json'
require 'sequel'
require 'rbnacl/libsodium'
require 'base64'

# user account information
class BaseUser < Sequel::Model
  plugin :single_table_inheritance, :type
  plugin :timestamps, :create=>:created_at, :update=>:updated_at, update_on_create: true
  
  # relations
  one_to_many :owned_urls, class: :Url, key: :owner_id
  many_to_many :urls, join_table: :permissions, left_key: :viewer_id, right_key: :url_id

  # associations
  plugin :association_dependencies, owned_urls: :destroy

  # restrictions
  set_allowed_columns :email, :account_status, :username

  def to_json(options = {})
    JSON({
      type: type,
      id: id,
      username: username,
      email: email
      },
      options)
  end
end

# Regular users with full credentials
class User < BaseUser
  def password=(new_password)
    new_salt = SecureDB.new_salt
    hashed = SecureDB.hash_password(new_salt, new_password)
    self.salt = new_salt
    self.password_hash = hashed
  end

  def password?(try_password)
    try_hashed = SecureDB.hash_password(salt, try_password)
    try_hashed == password_hash
  end
end

# SSO users without passwords
class SsoUser < BaseUser
end