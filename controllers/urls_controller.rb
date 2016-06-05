# url shortner web service
class UrlShortnerAPI < Sinatra::Base
  def authorized_affiliated_url(env, url_id)
    user = authenticated_user(env)
    all_urls = FindAllUserUrls.call(id: user['id'])
    test = all_urls.select { |url| url.id == url_id.to_i }.first
  rescue
    nil
  end

  get '/api/v1/urls/:id' do
    content_type 'application/json'
    url = authorized_affiliated_url(env, params[:id])
    halt(401, 'Not authorized, or url might not exist') unless url
    url.to_full_json
  end

  # post a new permission to url given a user id
  post '/api/v1/urls/:url_id/viewer/:viewer_id' do
    url = authorized_affiliated_url(env, params[:url_id])
    halt(401, 'Not authorized, or url might not exist') unless url

    begin
      result = AddPermissionForUrl.call(
        viewer_id: params[:viewer_id],
        url_id: params[:url_id])
      status result ? 201 : 403
    rescue => e
      logger.info "FAILED to add permission to URL: #{e.inspect}"
      halt 400
    end
  end
end