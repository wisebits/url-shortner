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
    views = url ? Url[id].views : []

    if url
      JSON.pretty_generate(data: url, relationships: views)
    else
      halt 404, "Url not found: #{id}"
    end
  end

  # post a new permission to url given a user id
  post '/api/v1/urls/:url_id/viewer/:username' do
    begin
      result = AddPermissionForUrl.call(
        user: User.where(username: params[:username]).first,
        url: Url.where(id: params[:url_id]).first)

      status result ? 201 : 403
    rescue => e
      logger.info "FAILED to add permission to URL: #{e.inspect}"
      halt 400
    end
  end
end
