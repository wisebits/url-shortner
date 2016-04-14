require 'sinatra'
require 'json'
require 'haml'
require 'base64'
require 'uri'
require_relative 'config/environments'
require_relative 'models/init'

# url shortner web application
class UrlShortnerAPI < Sinatra::Base
  before do
    Url.setup
  end

  get '/?' do
    haml :index
  end

  get '/api/v1/urls/?' do
    content_type 'application/json'
    JSON.pretty_generate(data: Url.all)
  end

  get '/api/v1/urls/:id/*' do
    content_type 'text/plain'
    begin
      attribute = params['splat'][0]
      Url.find(params[:id]).instance_variable_get("@#{attribute}")
    rescue => e
      status 404
      e.inspect
    end
  end

  get '/api/v1/urls/:id.json' do
    content_type 'application/json'
    begin
      { url_details: Url.find(params[:id]) }.to_json
    rescue => e
      status 404
      logger.info "FAILED to GET url: #{e.inspect}"
    end
  end

  post '/api/v1/urls/?' do
    content_type 'application/json'

    begin
      new_data = JSON.parse(request.body.read)
      new_url_data = Url.new(new_data)
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
