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

  post '/api/v1/users' do
    content_type 'application/json'
    begin
      data = JSON.parse(request.body.read)
  
      new_user = CreateUser.call(
        username: data['username'],
        email: data['email'],
        password: data['password'])

      new_user.to_json
    rescue => e
      #logger.info 
      halt 400, "failed to create new user account: #{e.inspect}"
    end

    #new_location = URI.join(@request_url.to_s + '/', new_user.username).to_s

    #status 201
    #headers('Location' => new_location)
  end
end