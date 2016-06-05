require 'base64'
require 'jose'

class ClientNotAuthorized < StandardError
  def initialize(msg='The client is not allowed to make this request')
    super
  end
end

# Encrypt and decrypt JWT
class SecureClientMessage
  def self.encrypt(object)
    JOSE::JWE.block_encrypt(
    	jwk256,
    	object.to_json,
    	{ 'alg' => 'dir', 'enc' => 'A256GCM', 'exp' => expiration }
    	).compact
  end

  def self.decrypt(jwe_compact)
    jwt, jwe = JOSE::JWE.block_decrypt(jwk256, jwe_compact)
    expired?(jwe) ? nil : jwt
  end

  def self.verified_data(signed_data)
    app_public_key = JOSE::JWK.from_okp(
      [:Ed25519, Base64.decode64(ENV['APP_PUBLIC_KEY'])])
    verified, data_json, _ = app_public_key.verify(signed_data)
    raise 'Client not authorized to send request' unless verified
    JSON.parse(data_json)
  rescue
    raise ClientNotAuthorized
  end  

  private_class_method

  def self.jwk256
    JOSE::JWK.from_oct(Base64.decode64(ENV['JWK256']))
  end

  def self.expiration
    one_week = 60 * 60 * 24 * 7
    (Time.now + one_week).to_i
  end

  def self.expired?(jwe)
    Time.now > Time.at(jwe.fields['exp'])
  end
end