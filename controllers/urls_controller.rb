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
      JSON.pretty_generate(data: url, relationships: permissions)
    else
      halt 404, "Url not found: #{id}"
    end
    
  end

  post '/api/v1/urls/?' do
    content_type 'application/json'

    begin
      new_data = JSON.parse(request.body.read)
      new_url = CreateNewUrl.call(title: new_data["title"], description: new_data["description"])
    rescue => e
      logger.info "Failed to create new url: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', saved_url.id.to_s).to_s
    status 201

    headers('Location' => new_location)
  end

  get '/api/v1/urls/:id/permissions/?' do
    content_type 'application/json'

    url = Url[params[:id]]

    JSON.pretty_generate(data: url.permissions)
  end

  get '/api/v1/urls/:url_id/permissions/:id/?' do
    content_type 'application/json'

    begin
      puts params[:id]
      #doc_url = URI.join(@request_url.to_s + '/', 'document')
      permission = Permission.where(url_id: params[:url_id], id: params[:id]).first
      halt(404, 'Permission not found') unless permission
      JSON.pretty_generate(data: {
        permission: permission     
        })
    rescue => e
      status 400
      logger.info "FAILED to process GET `d request: #{e.inspect}"
      e.inspect
    end
  end

  post '/api/v1/urls/:url_id/permissions/?' do
    begin
      new_data = JSON.parse(request.body.read)
      url = Url[params[:url_id]]
      saved_permission = url.add_permission(new_data)
    rescue => e
      logger.info "FAILED to create new permission: #{e.inspect}"
      halt 400
    end
    status 201
    new_location = URI.join(@request_url.to_s + '/', saved_permission.id.to_s).to_s
    headers('Location' => new_location)
  end
end
