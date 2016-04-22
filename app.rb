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
      full_url = new_data["full_url"]
      saved_url = Url.new(title: new_data["title"], 
        description: new_data["description"])
      saved_url.url = full_url
      saved_url.shorturl = saved_url.url
      saved_url.save
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
      url = Url[params[:url_idl]]
      saved_permission = url.add_permission(new_data)
    rescue => e
      logger.info "FAILED to create new permission: #{e.inspect}"
      halt 400
    end
    status 201
    new_location = URI.join(@request_url.to_s + '/', saved_config.id.to_s).to_s
    headers('Location' => new_location)
  end
end
