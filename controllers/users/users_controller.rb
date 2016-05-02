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
end