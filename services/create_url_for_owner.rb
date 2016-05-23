# Sevice to create a url for user
class CreateUrlForOwner
  def self.call(user:, full_url:, title:, description:)
    saved_url = user.add_owned_url(CreateUrl.call(
      full_url: full_url,
      description: description,
      title: title))
    saved_url.save
  end
end
