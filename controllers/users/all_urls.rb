class UrlShortnerAPI < Sinatra::Base
	get '/api/v1/users/:username/urls/?' do
    content_type 'application/json'

    begin
      halt 401 unless authorized_user?(env, params[:username])
      all_urls = FindAllUserUrls.call(user)
      JSON.pretty_generate(data: all_urls)
    rescue => e
      logger.info "FAILED to find urls for user: #{e}"
      halt 404
    end
  end
end