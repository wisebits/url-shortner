# url shortner web service
class UrlShortnerAPI < Sinatra::Base
  def authorized_affiliated_url(env, url_id, count)
    user = authenticated_user(env)
    all_urls = FindAllUserUrls.call(id: user['id'])
    found_url = all_urls.select { |url| url.id == url_id.to_i }.first
    if found_url.owner_id != user['id'] and count
      found_url.add_view(CreateView.call(location: 'Hsinchu, Taiwan', ip_address: "127.0.0.1"))
    end
    found_url
  rescue
    nil
  end

  get '/api/v1/urls/:id' do
    content_type 'application/json'
    url = authorized_affiliated_url(env, params[:id], count=true)
    halt(401, 'Not authorized, or url might not exist') unless url
    url.to_full_json
  end

  # post a new permission to url given a user id
  post '/api/v1/urls/:url_id/viewers/?' do
    content_type 'application/json'
    begin
      criteria = JSON.parse request.body.read
      viewer = FindBaseUserByEmail.call(criteria['email'])
      url = authorized_affiliated_url(env, params[:url_id], count=false)
      raise('Unauthorized or not found') unless url && viewer

      viewer = AddPermissionForUrl.call(
        viewer_id: viewer.id,
        url_id: url.id)
      viewer ?  status(201) : raise('Could not add viewer')
    rescue => e
      logger.info "FAILED to add viewer to url: #{e.inspect}"
      halt 401
    end
    viewer.to_json
  end
end