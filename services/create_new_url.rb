# Serice to save a new url
class CreateNewUrl
  def self.call(full_url:, title:, description:)
    saved_url = Url.new(title: title, description: description)
    saved_url.url = full_url
    saved_url.shorturl = saved_url.url
    saved_url.save
  end
end
