# service object to create new users using all columns
class CreateNewUser
  def self.call(username:, email:, password:)
    user = User.new(username: username)
    user.email = email
    user.password = password
    user.save
  end
end