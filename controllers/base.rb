require 'sinatra'
require 'json'

# url shortner web service
class UrlShortnerAPI < Sinatra::Base
  before do
    host_url = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    @request_url = URI.join(host_url, request.path.to_s)
  end

  get '/?' do
    'Url Shortner service is up and running!'
  end

  get '/api/v1/?' do
  	# TODO: show all routes...
  end
end