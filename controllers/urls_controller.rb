# url shortner web service
class UrlShortnerAPI < Sinatra::Base
  def affiliated_url(env, url_id)
    user = authenticated_user(env)
    all_urls = FindAllUserUrls.call(id: user['id'])
    all_urls.select { |url| url.id == url_id.to_i }.first
  rescue
    nil
  end

  get '/api/v1/urls/?' do
    content_type 'application/json'
    JSON.pretty_generate(data: Url.all)
  end

  get '/api/v1/urls/:id' do
    content_type 'application/json'
    url_id = params[:id]
    url = affiliated_url(env, url_id)
    halt(401, 'Not authorized, or url might not exist') unless url
    JSON.pretty_generate(data: url, relationships: views)
  end

  # post a new permission to url given a user id
  post '/api/v1/urls/:url_id/viewer/:viewer_id' do
    begin
      viewer_id = params[:viewer_id]
      url_id = params[:url_id]
      result = AddPermissionForUrl.call(
        viewer_id: viewer_id,
        url_id: url_id)

      status result ? 201 : 403
    rescue => e
      logger.info "FAILED to add permission to URL: #{e.inspect}"
      halt 400
    end
  end
end
