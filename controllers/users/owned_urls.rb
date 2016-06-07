# Owned urls controllers
class UrlShortnerAPI < Sinatra::Base
  post '/api/v1/users/:owner_id/owned_urls/?' do
    content_type 'application/json'
    
    begin
      halt 401 unless authorized_user?(env, params[:owner_id])

      new_data = JSON.parse(request.body.read)
      saved_url = CreateUrlForOwner.call(
        owner_id: params[:owner_id],
        full_url: new_data['full_url'], 
        title: new_data['title'], 
        description: new_data['description'])

      #new_location = URI.join(@request_url.to_s + '/', saved_url.id.to_s).to_s
    rescue => e
      logger.info "FAILED to create new url: #{e.inspect}"
      halt 400
    end

    status 201
    saved_url.to_json
  end
end