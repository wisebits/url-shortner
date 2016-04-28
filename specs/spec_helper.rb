ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'

Dir.glob('./{config,models,services,helpers,controllers}/init.rb').each do |file|
  require file
end

include Rack::Test::Methods

def app
	UrlShortnerAPI 
end

def invalid_id(resource)
	case [resource]
	when [Url]
  	(resource.max(:id) || 0) + 1
  #when [Permission]
  #	SecureRandom.uuid
  else
  	raise "INVALID_ID: unknown primary key for #{resource}"
  end
end

