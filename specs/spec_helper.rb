ENV['RACK_ENV'] = 'test'

require_relative '../app'

def app
	UrlShortnerAPI 
end