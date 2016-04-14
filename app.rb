require 'sinatra'
require 'json'
require 'haml'
require 'openssl'
require 'base64'
require 'uri'
require_relative 'config/environments'
require_relative 'models/init'
require_relative './helpers/api_helper.rb'

# url shortner web application
class UrlShortnerAPI < Sinatra::Base

  helpers ApiHelper

  before do
    host_url = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    @request_url = URI.join(host_url, request.path.to_s)
  end

  get '/?' do
    haml :index
  end

  get '/api/v1/urls/?' do
    content_type 'application/json'
    JSON.pretty_generate(data: Url.all)
  end

  get '/api/v1/urls/:id/*' do
    content_type 'application/json'
    
    begin
      id = params['id']
      attribute = params['splat'][0]
      url = Url.where(id: id).first.values#.first.instance_variable_get("@#{attribute}")
      halt(404, 'Url not found') unless url
      JSON.pretty_generate(data: {
          url_id: url[:id],
          "#{attribute}": url[:"#{attribute}"]
        })
    rescue
      status 400
      logger.info "FAILED to process GET attribute for id: #{id}"
      e.inspect
    end

  end

  get '/api/v1/urls/:id' do
    content_type 'application/json'

    id = params[:id]
    url = Url[id]

    if url
      JSON.pretty_generate(data: url)
    else
      halt 404, "Url not found: #{id}"
    end
    
  end

  post '/api/v1/urls/?' do
    content_type 'application/json'

    begin
      new_data = JSON.parse(request.body.read)
      full_url = new_data["full_url"]
      new_data["short_url"] = short_url_creator(full_url)
      puts new_data["short_url"]
      saved_url = Url.create(new_data)

    rescue => e
      logger.info "Failed to create new url: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', saved_url.id.to_s).to_s
    status 201

    headers('Location' => new_location)
  end
end
