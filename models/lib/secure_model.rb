require 'base64'
require 'rbnacl/libsodium'

module SecureModel
  def key
    @key ||= Base64.strict_decode64(ENV['DB_KEY'])
  end

  def encrypt(plaintext)
    if plaintext
      simple_box = RbNaCl::SimpleBox.from_secret_key(key)
      ciphertext = simple_box.encrypt(plaintext)
      Base64.strict_encode64(ciphertext)
    end
  end

  def decrypt(ciphertext_64)
    if full_url
      simple_box = RbNaCl::SimpleBox.from_secret_key(key)
      ciphertext = Base64.strict_decode64(ciphertext_64)
      simple_box.decrypt(ciphertext)
    end
  end

  def hash_password(salt, pwd)
    opslimit = 2**20
    memlimit = 2**24
    digest_size = 64
    RbNaCl::PasswordHash.scrypt(pwd, salt, opslimit, memlimit, digest_size)
  end
end