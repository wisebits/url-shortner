require_relative './spec_helper'

describe 'URL resource calls' do
  before do
    Permission.dataset.destroy
    Url.dataset.destroy
    User.dataset.destroy
    View.dataset.destroy
  end

  describe 'Get index of all URLs for a user' do
    before do
      @my_user = CreateUser.call(
        username: 'alice',
        email: 'alice@gmail.com',
        password: 'alicepassword')

      @other_user = CreateUser.call(
        username: 'bob',
        email: 'bob@gmail.com',
        password: 'bobpassword')

      @my_urls = []
      3.times do |i|
        @my_urls << @my_user.add_owned_url(CreateUrl.call(
          full_url: "https://#{@my_user.id}inwonderland#{i}.com",
          description: "Alice in Wonderland",
          title: "A world of wonders")) 
        
        @other_user.add_owned_url(CreateUrl.call(
          full_url: "https://#{@other_user.id}inwonderland#{i}.com",
          description: "Bob in Wonderland",
          title: "A world of wonders"))
      end

      # Adding permission for user to another user's urls
      @other_user.owned_urls.each.with_index do |url, i|
        @my_urls << @my_user.add_url(url) if i < 2
      end
    end

    it 'HAPPY: should find all URLs for a user' do
      _, auth_token = AuthenticateUser.call(
        username: 'alice',
        password: 'alicepassword')

      result = get "/api/v1/users/#{@my_user.id}/urls", nil, { "HTTP_AUTHORIZATION" => "Bearer #{auth_token}" }
      _(result.status).must_equal 200
      urls = JSON.parse(result.body)

      valid_ids = @my_urls.map(&:id)
      _(urls['data'].count).must_equal 5
      urls['data'].each do |url|
        _(valid_ids).must_include url['id']
      end
    end
  end

  describe 'Finding existing urls' do
    before do
      @my_user = CreateUser.call(
        username: 'alice',
        email: 'alice@gmail.com',
        password: 'alicepassword')

      @other_user = CreateUser.call(
        username: 'bob',
        email: 'bob@gmail.com',
        password: 'bobpassword')

      @my_urls = []
      3.times do |i|
        @my_urls << @my_user.add_owned_url(CreateUrl.call(
          full_url: "https://#{@my_user.id}inwonderland#{i}.com",
          description: "Alice in Wonderland",
          title: "A world of wonders")) 
        
        @other_user.add_owned_url(CreateUrl.call(
          full_url: "https://#{@other_user.id}inwonderland#{i}.com",
          description: "Bob in Wonderland",
          title: "A world of wonders"))
      end

      # Adding permission for user to another user's urls
      @other_user.owned_urls.each.with_index do |url, i|
        @my_urls << @my_user.add_url(url) if i < 2
      end
    end

    it 'HAPPY: should find an existing URL' do
      new_url = CreateUrl.call(
          full_url: "https://aliceinwonderland.com",
          description: "Alice in Wonderland",
          title: "A world of wonders" 
          )
      new_views = (1..3).map do |i|
        new_url.add_view(CreateView.call(location: 'Wonderland', ip_address: "1.0.0.#{i}"))
      end

      _, auth_token = AuthenticateUser.call(
        username: 'alice',
        password: 'alicepassword')

      get "/api/v1/urls/#{new_url.id}", nil, { "HTTP_AUTHORIZATION" => "Bearer #{auth_token}" }
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['data']['id']).must_equal new_url.id
      3.times do |i|
        _(results['relationships'][i]['id']).must_equal new_views[i].id
      end
    end

    it 'SAD: should not find non-existent URLs' do
      get "/api/v1/urls/#{invalid_id(Url)}"
      _(last_response.status).must_equal 401
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