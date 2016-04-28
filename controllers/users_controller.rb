# url shortner web service
class UrlShortnerAPI < Sinatra::Base
  get '/api/v1/users/:username' do
    content_type 'application/json'

    username = params[:username]
    user = User.where(username: username).first

    if user
      urls = user.owned_urls
      JSON.pretty_generate(data: user, relationships: urls)
    else
      halt 404, "PROJECT NOT FOUND: #{username}"
    end
  end

  get '/api/v1/users/:username/urls/?' do
    content_type 'application/json'

    begin
      username = params[:username]
      user = User.where(username: username).first

      my_urls = Url.where(owner_id: user.id).all
      other_urls = Url.join(:permissions, url_id: :id).where(viewer_id: user.id).all

      all_urls = my_urls + other_urls
      JSON.pretty_generate(data: all_urls)

    rescue => e
      logger.info "failed to get urls for #{username}: #{e}"
      halt 404
    end
  end

  post '/api/v1/users/?' do
    begin
      data = JSON.parse(request.body.read)
      new_user = CreateNewUser.call(
        username: data['username'],
        email: data['email'],
        password: data['password'])
    rescue => e
      logger.info "failed to create new user account: #{e.inspect}"
      halt 400
    end
  end

  post '/api/v1/users/:username/urls/?' do
    begin
      username = params[:username]
      new_data = JSON.parse(request.body.read)

      user = User.where(username: username).first
      new_url = CreateNewUrl.call(full_url: new_data['full_url'], title: new_data['title'], description: new_data['description'])
      saved_url = user.add_owned_url(new_url)
      saved_url.save

    rescue => e
      logger.info "FAILED to create new url: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', saved_url.id.to_s).to_s

    status 201
    headers('Location' => new_location)
  end
end