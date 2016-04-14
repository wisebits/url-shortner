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
    #Url.setup
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
      new_url_data = Url.create(new_data)
    rescue => e
      logger.info "Failed to create new url: #{e.inspect}"
      halt 400
    end
  end
end
