# Sevice to create a url for user
class CreateUrlForOwner
  def self.call(user:, full_url:, title:, description:)
    
    saved_url = user.add_owned_url(CreateUrl.call(
      full_url: "https://aliceinwonderland.com",
      description: "Alice in Wonderland",
      title: "A world of wonders"))
    saved_url.save
  end
end
