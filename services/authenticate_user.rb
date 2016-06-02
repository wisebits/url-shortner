# Find user account and check password
class AuthenticateUser
  def self.call(username:, password:)
    return nil unless username && password
    user = User.first(username: username)
    if user && user.password?(password)
      [user, JWE.encrypt(user)]
    else
      nil
    end
  end
end
