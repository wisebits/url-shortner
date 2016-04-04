require 'json' 

# properties of a short url
class ShortUrl
	STORE_DIR = 'db/'.freeze

	attr_accessor :id, :url, :title, :description, :public

	def initialize(new_url)
		@id = new_url['id'] # id of a url
		@link = new_url['link'] # url link
		@title = new_url['title'] # title of url
		@description = new_url['description'] # additional information for url
		@public = new_url['public'] # url privacy
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
			   public: @public },
			  options)
	end

	def self.find(find_id)
		url_file = File.read(STORE_DIR + find_id + '.txt')
		ShortUrl.new JSON.parse(url_file)
	end
end