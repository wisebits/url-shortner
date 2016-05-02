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
  # get '/api/v1/urls/?' do
   # content_type 'application/json'
  #  JSON.pretty_generate(data: Url.all)
 # end

  get '/api/v1/urls/:id' do
    content_type 'application/json'

    id = params[:id]
    url = Url[id]
    permissions = url ? Url[id].users : []

    if url
      JSON.pretty_generate(data: url, relationships: permissions)
    else
      halt 404, "Url not found: #{id}"
    end
  end

  # post a new permission to url given a user id
  post '/api/v1/urls/:url_id/permissions/:viewer_id' do
    begin
      result = AddPermissionForUrl.call(
        user: User.where(id: params[:viewer_id]).first,
        url: Url.where(id: params[:url_id]).first)
      status result ? 201 : 403
    rescue => e
      logger.info "FAILED to add permission to URL: #{e.inspect}"
      halt 400
    end
  end

=begin
  post '/api/v1/urls/?' do
    content_type 'application/json'

    begin
      new_data = JSON.parse(request.body.read)
      new_url = CreateNewUrl.call(full_url: new_data["full_url"], title: new_data["title"], description: new_data["description"])
    rescue => e
      logger.info "Failed to create new url: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', new_url['full_url'].to_s).to_s
    status 201

    headers('Location' => new_location)
  end
=end
end
