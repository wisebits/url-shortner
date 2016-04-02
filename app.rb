require 'sinatra'
require 'json'
require 'base64'
require_relative 'db/url'

# Url Shortner web application
class UrlShortnerAPI < Sinatra::Base
  
  get '/?' do
    'Url Shortner is ready to crunch some Urls'
  end

end
