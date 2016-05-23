require 'sinatra'
require 'json'
require 'rack/ssl-enforcer'

# url shortner web service
class UrlShortnerAPI < Sinatra::Base
  enable :logging

  configure :production do
    use Rack::SslEnforcer
  end

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