require 'json'
require 'openssl'
require 'base64'

# properties of a short url
class ShortUrl
  STORE_DIR = 'db/'.freeze

  attr_accessor :id, :url, :title, :description, :public

  def initialize(new_url)
    @id = new_url['id'] || new_id # id of a url
    @link = new_url['link'] # url link
    @title = new_url['title'] # title of url
    @description = new_url['description'] # additional information for url
    @public = new_url['public'] # url privacy
    @short_url = "http://wise.url/"+ Base64.urlsafe_encode64(Digest::SHA256.digest(new_url['link']))[0..6]
  end

  def self.setup
    Dir.mkdir(ShortUrl::STORE_DIR) unless Dir.exist? STORE_DIR
  end

  def self.all
    Dir.glob(STORE_DIR + '*.txt').map do |filename|
      filename.match(%r{db\/(.*)\.txt})[1]
    end
  end

  def to_json(options = {})
    JSON({ id: @id,
           link: @link,
           title: @title,
           description: @description,
           short_url: @short_url,
           public: @public },
         options)
  end

  def new_id
    Base64.urlsafe_encode64(Digest::SHA256.digest(Time.now.to_s))
  end

  def save
    File.open(STORE_DIR + @id + '.txt', 'w') do |file|
      file.write(to_json)
    end
  end

  def self.find(find_id)
    url_file = File.read(STORE_DIR + find_id + '.txt')
    ShortUrl.new JSON.parse(url_file)
  end
end
