# url shortner web service
class UrlShortnerAPI < Sinatra::Base
  # store a view (a view is consider as a unique visit)
  # TODO: check for uniqueness of view through the user
  
  get '/api/v1/urls/:id/views/?' do
    content_type 'application/json'

    url = Url[params[:id]]

    JSON.pretty_generate(data: url.views)
  end

  post '/api/v1/urls/:id/views/?' do
    begin
      new_data = JSON.parse(request.body.read)
      url = Url[params[:id]]
      new_view = CreateNewView.call(location: new_data['location'], ip_address: new_data['ip_address'])
      saved_view = url.add_view(new_view)
      saved_view.save
    rescue => e
      logger.info "FAILED to create new view for url: #{e.inspect}"
      halt 400
    end
    status 201
    new_location = URI.join(@request_url.to_s + '/', saved_view.id.to_s).to_s
    headers('Location' => new_location)
  end
end