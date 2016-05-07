# Sinatra Application Controllers
class UrlShortnerAPI < Sinatra::Base
  get '/api/v1/users/:username/authenticate' do
    content_type 'application/json'

    username = params[:username]
    password = params[:password]

    user = FindAndAuthenticateUser.call(
      username: username, password: password)

    if user
      user.to_json
    else
      halt 401, "Account #{username} could not be authenticated"
    end
  end
end
