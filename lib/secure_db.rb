require 'base64'
require 'rbnacl/libsodium'

module SecureDB
  def self.key
    Base64.strict_decode64(ENV['DB_KEY'])
  end

  def self.encrypt(plaintext)
    if plaintext
      simple_box = RbNaCl::SimpleBox.from_secret_key(key)
      ciphertext = simple_box.encrypt(plaintext)
      Base64.strict_encode64(ciphertext)
    end
  end

  def self.decrypt(full_url)
    if full_url
      simple_box = RbNaCl::SimpleBox.from_secret_key(key)
      ciphertext = Base64.strict_decode64(full_url)
      simple_box.decrypt(ciphertext)
    end
  end

  def self.new_salt
    Base64.strict_encode64(
      RbNaCl::Random.random_bytes(RbNaCl::PasswordHash::SCrypt::SALTBYTES))
  end

  def self.hash_password(salt, pwd)
    opslimit = 2**20
    memlimit = 2**24
    digest_size = 64
    digest = RbNaCl::PasswordHash.scrypt(pwd, Base64.strict_decode64(salt), opslimit, memlimit, digest_size)
    Base64.strict_encode64(digest)
  end
end