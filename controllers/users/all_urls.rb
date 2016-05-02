class UrlShortnerAPI < Sinatra::Base
	get '/api/v1/users/:username/urls/?' do
    content_type 'application/json'

    begin
      user = User.where(username: params[:username]).first
      all_urls = FindAllUserUrls.call(user)
      JSON.pretty_generate(data: all_urls)
    rescue => e
      logger.info "FAILED to find urls for user #{params[:username]}: #{e}"
      halt 404
    end
  end
end