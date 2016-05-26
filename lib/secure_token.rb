require 'base64'
require 'jose'

# Encrypt and decrypt JWT
class JWE
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