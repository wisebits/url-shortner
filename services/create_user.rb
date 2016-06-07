# service object to create new users using all columns
class CreateUser
  def self.call(signed_full_registration)
    registration = SecureClientMessage.verified_data(signed_full_registration)
    create_new_user(registration)
  end

  private_class_method

  def self.create_new_user(registration)
    user = User.new(username: registration['username'],
      email: registration['email'])
    user.password = registration['password']
    user.save
  end
end