class UrlShortnerAPI < Sinatra::Base
	post '/api/v1/users/:username/owned_urls/?' do
    begin
      new_data = JSON.parse(request.body.read)
      user = User.where(username: params[:username]).first
      saved_url = CreateUrlForOwner.call(user, full_url: new_data['full_url'], title: new_data['title'], description: new_data['description'])
      new_location = URI.join(@request_url.to_s + '/', saved_url.id.to_s).to_s
    rescue => e
      logger.info "FAILED to create new url: #{e.inspect}"
      halt 400
    end

    status 201
    headers('Location' => new_location)
  end

  get '/api/v1/users/:username/owned_urls/?' do
  	content_type 'application/json'

  	begin
  		user = User.where(username: params[:username]).first
  		owned_urls = user.owned_urls
  		JSON.pretty_generate(data: owned_urls)
  	rescue => e
  		logger.info "FAILED to find urls for user #{params[:username]}: #{e}"
  		halt 404
  	end
  end
end