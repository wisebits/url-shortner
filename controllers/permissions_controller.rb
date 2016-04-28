# url shortner web service
class UrlShortnerAPI < Sinatra::Base
  # return the users that have permissioon for the url
  get '/api/v1/urls/:id/permissions/?' do
    content_type 'application/json'

    url = Url[params[:id]]

    JSON.pretty_generate(data: url.users)
  end

  # post a new permission to url given a user id
  post '/api/v1/urls/:url_id/permissions/:viewer_id' do
    begin
      user_id = params[:viewer_id]
      url_id = params[:url_id]

      user = User.where(id: user_id).first
      url = Url.where(id: url_id).first

      user.add_url(url)
      user.save
      
    rescue => e
      logger.info "FAILED to create new permission: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', user.id.to_s).to_s

    status 201
    headers('Location' => new_location)
  end


  # TODO: permission for an url should only be viewable by ownder of the url -> move to the user controller possibly
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
  
  # TODO: this can only be set by the user that owns the url. Needs to be moved to the user controller
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