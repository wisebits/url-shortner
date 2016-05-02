# Serice to save a new url
class CreateUrlForOwner
  def self.call(user, full_url:, title:, description:)
    saved_url = user.add_owned_url(title: title, description: description)
    saved_url.url = full_url
    saved_url.shorturl = saved_url.url
    saved_url.save
  end
end
