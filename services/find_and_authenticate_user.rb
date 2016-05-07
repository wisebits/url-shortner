# Find user account and check password
class FindAndAuthenticateUser
  def self.call(username:, password:)
    return nil unless username && password
    user = User.where(username: username).first
    user && user.password?(password) ? user : false
  end
end
