# Find user account and check password
class AuthenticateUser
  def self.call(username:, password:)
    return nil unless username && password
    user = User.where(username: username).first
    if user && user.password?(password)
      [user, JWE.encrypt(user)]
    else
      false
    end
  end
end
