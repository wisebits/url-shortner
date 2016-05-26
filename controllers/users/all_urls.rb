class UrlShortnerAPI < Sinatra::Base
  get '/api/v1/users/:id/urls/?' do
    content_type 'application/json'

    begin
      id = params[:id]
      halt 401 unless authorized_user?(env, id)
      all_urls = FindAllUserUrls.call(id: id)
      JSON.pretty_generate(data: all_urls)
    rescue => e
      logger.info "FAILED to find urls for user: #{e}"
      halt 404
    end
  end
end