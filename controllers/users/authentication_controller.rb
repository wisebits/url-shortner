# Sinatra Application Controllers
class UrlShortnerAPI < Sinatra::Base
  post '/api/v1/users/authenticate' do
    content_type 'application/json'

    credentials = JSON.parse(request.body.read)
    user = FindAndAuthenticateUser.call(
      username: credentials['username'],
      password: credential['password'])

    if user
      user.to_json
    else
      halt 401, 'Account could not be authenticated'
    end
  end
end
