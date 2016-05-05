# service object to create new users using all columns
class CreateUser
  def self.call(username:, email:, password:)
    user = User.new(username: username)
    user.email = email
    user.password = password
    user.save
    user
  end
end