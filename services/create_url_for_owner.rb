# Sevice to create a url for user
class CreateUrlForOwner
  def self.call(owner_id:, full_url:, title:, description:)
  	owner = User[owner_id]
    saved_url = owner.add_owned_url(CreateUrl.call(
      full_url: "https://aliceinwonderland.com",
      description: "Alice in Wonderland",
      title: "A world of wonders"))
    saved_url.save
  end
end
