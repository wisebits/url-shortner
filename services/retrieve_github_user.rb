require 'http'

# Find or create an SsoUser based on Github code
class RetrieveSsoUser
  def self.call(code)
    access_token = get_access_token(code)
    github_user = get_github_user(access_token)
    sso_user = find_or_create_sso_user(github_user)

    [sso_user, SecureClientMessage.encrypt(sso_user)]
  end

  private_class_method

  def self.get_access_token(code)
  	HTTP.headers(accept: 'application/json').post(
  		'https://github.com/login/oauth/access_token',
  		form: {
  			client_id: ENV['GH_CLIENT_ID'],
  			client_secret: ENV['GH_CLIENT_SECRET'],
  			code: code
  			}).parse['access_token']
  end

  def self.get_github_user(access_token)
  	gh_user = HTTP.headers(
  		user_agent: 'URL Shortner',
  		authorization: "token #{access_token}",
  		accept: 'application/json'
  		).get('https://api.github.com/user').parse
  	{ username: gh_user['login'], email: gh_user['email']}
  end

  def self.find_or_create_sso_user(github_user)
    SsoUser.first(github_user) || SsoUser.create(github_user)
  end
end