require 'sinatra'
require 'json'
require 'haml'
require 'openssl'
require 'base64'
require 'uri'
#require_relative 'config/environments'
#require_relative 'services/init'
#require_relative './helpers/api_helper.rb'


# url shortner web service
class UrlShortnerAPI < Sinatra::Base
  get '/api/v1/urls/?' do
    content_type 'application/json'
    JSON.pretty_generate(data: Url.all)
  end

  get '/api/v1/urls/:id' do
    content_type 'application/json'

    id = params[:id]
    url = Url[id]
    permissions = url ? Url[id].permissions : []

    if url
      JSON.pretty_generate(data: url, relationships: users)
    else
      halt 404, "Url not found: #{id}"
    end
    
  end

  post '/api/v1/urls/?' do
    content_type 'application/json'

    begin
      new_data = JSON.parse(request.body.read)
      new_url = CreateNewUrl.call(full_url: new_data["full_url"], title: new_data["title"], description: new_data["description"])
    rescue => e
      logger.info "Failed to create new url: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', saved_url.id.to_s).to_s
    status 201

    headers('Location' => new_location)
  end
end
