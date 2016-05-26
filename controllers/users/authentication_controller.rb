# Sinatra Application Controllers
class UrlShortnerAPI < Sinatra::Base
  post '/api/v1/users/authenticate' do
    content_type 'application/json'

    credentials = JSON.parse(request.body.read)
    user, auth_token = AuthenticateUser.call(
      username: credentials['username'],
      password: credentials['password'])

    if user
      { user: user, auth_token: auth_token }.to_json
    else
      halt 401, 'Account could not be authenticated'
    end
  end
end
