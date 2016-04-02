require 'json'

# Properties of a short url
class ShortUrl
  attr_accessor :id, :url, :title, :description, :public

  def initialize(new_url)
    @id = new_url['id'] #id of a url
    @link = new_url['link'] #url link
    @title = new_url['title'] #title for url
    @description = new_url['description'] #additional information for url
    @public = new_url['public'] #url privacy
  end
 
end