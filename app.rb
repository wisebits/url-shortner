require 'sinatra'
require 'json'
require 'base64'
require_relative 'models/url'

# url shortner web application
class UrlShortnerAPI < Sinatra::Base
  before do
    ShortUrl.setup
  end

  get '/?' do
    'Hello, World!'
  end

  get '/api/v1/urls/?' do
    content_type 'application/json'
    id_list = ShortUrl.all
    { url_id: id_list }.to_json
  end

  get '/api/v1/urls/:id.json' do
    content_type 'application/json'
    begin
      { url: ShortUrl.find(params[:id]) }.to_json
    rescue => e
      status 404
      logger.info "FAILED to GET url: #{e.inspect}"
    end
  end
end