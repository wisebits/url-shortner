# url shortner web service
class UrlShortnerAPI < Sinatra::Base
  get '/api/v1/users/:id' do
    content_type 'application/json'

    id = params[:id]
    halt 401 unless authorized_user?(env, id)
    user = User.where(id: id).first

    if user
      urls = user.owned_urls
      JSON.pretty_generate(data: user, relationships: urls)
    else
      halt 404, "USER NOT FOUND: #{id}"
    end
  end

  # to post for users
  post '/api/v1/users/?' do
    begin
      signed_full_registration = request.body.read
      new_user = CreateUser.call(signed_full_registration)
    rescue ClientNotAuthorized => e
      halt 401, e.to_s
    rescue => e
      logger.info "FAILED to create new account: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', new_user.username).to_s

    status 201
    headers('Location' => new_location)
  end
end