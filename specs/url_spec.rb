require_relative './spec_helper'

describe 'URL resource calls' do
  before do
    Permission.dataset.destroy
    Url.dataset.destroy
    User.dataset.destroy
    View.dataset.destroy
  end

  describe 'Finding existing urls' do
    it 'HAPPY: should find an existing project' do
      new_url = CreateUrl.call(
          full_url: "https://aliceinwonderland.com",
          description: "Alice in Wonderland",
          title: "A world of wonders" 
          )
      new_views = (1..3).map do |i|
        new_url.add_view(CreateView.call(location: 'Wonderland', ip_address: "1.0.0.#{i}"))
      end

      get "/api/v1/urls/#{new_url.id}"
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['data']['id']).must_equal new_url.id
      3.times do |i|
        _(results['relationships'][i]['id']).must_equal new_views[i].id
      end
    end
  end

  describe 'Add permission to a url' do
    it 'HAPPY: should be able to add permission to url' do
      owner = CreateUser.call(
        username: 'alice',
        email: 'alice@gmail.com',
        password: 'mypassword')
     
      viewer = CreateUser.call(
        username: 'bob',
        email: 'bob@gmail.com',
        password: 'mypassword')
     
      url = owner.add_owned_url(CreateUrl.call(
          full_url: "https://aliceinwonderland3.com",
          description: "Alice in Wonderland",
          title: "A world of wonders" 
          ))

      result = post "/api/v1/urls/#{url.id}/viewer/#{viewer.username}"
      _(result.status).must_equal 201
      _(viewer.urls.map(&:id)).must_include url.id
    end

    it 'BAD: should not be able to add url owner as viewer' do
      owner = CreateUser.call(
        username: 'alice',
        email: 'alice@gmail.com',
        password: 'mypassword')
     
      viewer = CreateUser.call(
        username: 'bob',
        email: 'bob@gmail.com',
        password: 'mypassword')
     
      url = owner.add_owned_url(CreateUrl.call(
          full_url: "https://aliceinwonderland3.com",
          description: "Alice in Wonderland",
          title: "A world of wonders" 
          ))

      result = post "/api/v1/urls/#{url.id}/viewer/#{owner.username}"
      _(result.status).must_equal 403
      _(owner.urls.map(&:id)).wont_include url.id
    end
  end
end