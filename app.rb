require 'sinatra'
require 'json'
require 'haml'
require 'base64'
require 'uri'
require_relative 'models/url'

# url shortner web application
class UrlShortnerAPI < Sinatra::Base
  before do
    ShortUrl.setup
  end

  get '/?' do
    haml :index
  end

  get '/api/v1/urls/?' do
    content_type 'application/json'
    id_list = ShortUrl.all
    { url_id: id_list }.to_json
  end

  get '/api/v1/urls/:id/*' do
    content_type 'text/plain'
    begin
      attribute = params['splat'][0]
      ShortUrl.find(params[:id]).instance_variable_get("@#{attribute}")
    rescue => e
      status 404
      e.inspect
    end
  end

  get '/api/v1/urls/:id.json' do
    content_type 'application/json'
    begin
      { url_details: ShortUrl.find(params[:id]) }.to_json
    rescue => e
      status 404
      logger.info "FAILED to GET url: #{e.inspect}"
    end
  end

  post '/api/v1/urls/?' do
    content_type 'application/json'

    begin
      new_data = JSON.parse(request.body.read)
      new_url_data = ShortUrl.new(new_data)
      if new_url_data.save
        logger.info "NEW URL STORED: #{new_url_data.id}"
      else
        halt 400, "Could not store url details: #{new_url_data}"
      end

      redirect 'api/v1/urls/' + new_url_data.id + '.json'
    rescue => e
      status 400
      logger.info "Failed to create new url: #{e}"
    end
  end
end
