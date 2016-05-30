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

  get '/api/v1/github_sso_url' do
    content_type 'application/json'

    gh_url = 'https://github.com/login/oauth/authorize'
    client_id = ENV['GH_CLIENT_ID']
    scope = 'user:email'

    { url: "#{gh_url}?client_id=#{client_id}&scope=#{scope}" }.to_json
  end

  get '/api/v1/github_account' do
    content_type 'application/json'
    begin
      sso_account, auth_token = RetrieveSsoAccount.call(params['code'])
      { account: sso_account, auth_token: auth_token }.to_json
    rescue => e 
      logger.info "FAILED to validate Github account: #{e.inspect}"
      halt 400
    end
  end
end