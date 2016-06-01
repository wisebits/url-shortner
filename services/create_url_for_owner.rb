# Sevice to create a url for user
class CreateUrlForOwner
  def self.call(owner_id:, full_url:, title:, description:)
  	owner = BaseUser[owner_id]
    saved_url = owner.add_owned_url(CreateUrl.call(
      full_url: full_url,
      description: description,
      title: title))
    saved_url.save
  end
end
