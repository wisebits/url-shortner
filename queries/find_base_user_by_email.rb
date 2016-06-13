# Query all users and return first email match
class FindBaseUserByEmail
  def self.call(search_email)
    BaseUser.first(email: search_email)
  end
end