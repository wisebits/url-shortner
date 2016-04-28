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
      saved_urls = user.add_owned_url(name: new_data[''])

    rescue => e

    end
  end
end