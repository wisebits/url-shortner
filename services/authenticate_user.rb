require 'jose'

# Find account and check password
class AuthenticateUser
  def self.call(signed_credentials)
    credentials = SecureClientMessage.verified_data(signed_credentials)
    user = User.first(username: credentials['username'])
    raise 'Credentials not found' unless passwords_match(user, credentials)
    [user, SecureClientMessage.encrypt(user)]
  end

  private_class_method

  def self.passwords_match(user, credentials)
    user && user.password?(credentials['password'])
  end
end