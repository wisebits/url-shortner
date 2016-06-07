# Sinatra Application Controllers
class UrlShortnerAPI < Sinatra::Base
  post '/api/v1/users/authenticate' do
    content_type 'application/json'
    begin
      user, auth_token = AuthenticateUser.call(request.body.read)
    rescue => e
      halt 401, e.to_s
    end

    { user: user, auth_token: auth_token }.to_json
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
      sso_user, auth_token = RetrieveSsoUser.call(params['code'])
      { user: sso_user, auth_token: auth_token }.to_json
    rescue => e 
      logger.info "FAILED to validate Github account: #{e.inspect}"
      halt 400
    end
  end
end