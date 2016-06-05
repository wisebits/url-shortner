ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
Dir.glob('./{config,lib,models,services,helpers,controllers}/init.rb').each do |file|
  require file
end

include Rack::Test::Methods

def app
	UrlShortnerAPI 
end

def invalid_id(resource)
  case [resource]
  when [Url]
    (resource.max(:id) || 0) + 1
  when [Permission]
  	SecureRandom.uuid
  else
    raise "INVALID_ID: unknown primary key for #{resource}"
  end
end

def random_str(size)
  chars = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
  chars.sample(size).join
end

def client_signed(data_hash)
  app_secret_key = JOSE::JWK.from_okp(
    [:Ed25519, Base64.decode64(ENV['APP_SECRET_KEY'])])
  app_secret_key.sign(data_hash.to_json).compact
end

def authorized_user_token(credentials)
  signed_credentials = client_signed(credentials)
  _, auth_token = AuthenticateUser.call(signed_credentials)
  auth_token
end

def create_client_user(registration_hash)
  signed_registration = client_signed(registration_hash)
  CreateUser.call(signed_registration)
end