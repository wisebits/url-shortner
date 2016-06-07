require_relative './spec_helper'

describe 'URL resource routes testing' do
  before do
    Permission.dataset.destroy
    Url.dataset.destroy
    User.dataset.destroy
    View.dataset.destroy
  end

  describe 'Get index of all URLs for a user' do
    before do
      @my_user = create_client_user(
        username: 'alice',
        email: 'alice@gmail.com',
        password: 'alicepassword')

      @other_user = create_client_user(
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
      auth_token = authorized_user_token(
        username: 'alice',
        password: 'alicepassword')

      result = get "/api/v1/users/#{@my_user.id}/urls", nil, 'HTTP_AUTHORIZATION' => "Bearer #{auth_token}" 
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
      @my_user = create_client_user(
        username: 'alice',
        email: 'alice@gmail.com',
        password: 'alicepassword')

      @other_user = create_client_user(
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
      new_url = @my_urls.first
      new_views = (1..3).map do |i|
        new_url.add_view(CreateView.call(location: 'Wonderland', ip_address: "1.0.0.#{i}"))
      end
      auth_token = authorized_user_token(
        username: 'alice',
        password: 'alicepassword')

      get "/api/v1/urls/#{new_url.id}", nil, 'HTTP_AUTHORIZATION' => "Bearer #{auth_token}" 
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['id']).must_equal new_url.id
      3.times do |i|
        _(results['relationships']['views'][i]['id']).must_equal new_views[i].id
      end
    end

    it 'SAD: should not find non-existent URLs' do
      get "/api/v1/urls/#{invalid_id(Url)}"
      _(last_response.status).must_equal 401
    end
  end

  describe 'Giver another user viewer permission to a url' do
    before do
      @owner = create_client_user(
        username: 'alice',
        email: 'alice@gmail.com',
        password: 'mypassword')
     
      @viewer = create_client_user(
        username: 'bob',
        email: 'bob@gmail.com',
        password: 'mypassword')
     
      @url = @owner.add_owned_url(CreateUrl.call(
          full_url: "https://aliceinwonderland3.com",
          description: "Alice in Wonderland",
          title: "A world of wonders" 
          ))
      
      @auth_token = authorized_user_token(
        username: 'alice', password: 'mypassword')
      @req_header = { 'CONTENT_TYPE' => 'application/json',
                     'HTTP_AUTHORIZATION' => "Bearer #{@auth_token}" }
    end

    it 'HAPPY: should add a viewer with permission to a url' do
      result = post "/api/v1/urls/#{@url.id}/viewer/#{@viewer.id}", nil, @req_header
      _(result.status).must_equal 201
      _(@viewer.urls.map(&:id)).must_include @url.id
    end

    it 'BAD: should not be able to add url owner as viewer' do
      result = post "/api/v1/urls/#{@url.id}/viewer/#{@owner.id}", nil, @req_header
      _(result.status).must_equal 403
      _(@owner.urls.map(&:id)).wont_include @url.id
    end
  end

  describe 'Creating new owned URL for user owner' do
    before do
      @user = create_client_user(
        username: 'alice',
        email: 'alice@gmail.com',
        password: 'mypassword')
      @auth_token = authorized_user_token(
        username: 'alice', password: 'mypassword')
      @req_header = { 'CONTENT_TYPE' => 'application/json',
                      'HTTP_AUTHORIZATION' => "Bearer #{@auth_token}" }
    end
    
    it 'HAPPY: should create a new owned URL for user' do
      req_body = { title: 'test', full_url: 'http://test.com', description: 'testings' }.to_json
      post "/api/v1/users/#{@user.id}/owned_urls/", req_body, @req_header
      _(last_response.status).must_equal 201
      _(last_response.body).wont_be_empty
    end

    it 'SAD: should not create URLs with duplicate names' do
      req_body = { title: 'test', full_url: 'http://test.com', description: 'testings' }.to_json
      2.times do
        post "/api/v1/users/#{@user.id}/owned_urls/", req_body, @req_header
      end
      _(last_response.status).must_equal 400
      _(last_response.body).must_be_empty
    end

    it 'BAD: should not create urls without authorization' do
      req_header = { 'CONTENT_TYPE' => 'application/json'}
      req_body = { title: 'test', full_url: 'http://test.com', description: 'testings' }.to_json
      post "/api/v1/users/#{@user.id}/owned_urls/", req_body, req_header
      _(last_response.status).must_equal 401
      _(last_response.location).must_be_nil
    end

    it 'HAPPY: should create additional information (e.g., views)' do
      url = CreateUrlForOwner.call(
        owner_id: @user.id,
        full_url: "https://aliceinwonderland.com",
        title: "A world of wonders",
        description: "Alice in Wonderland",)
      view = CreateView.call(location: 'Wonderland', ip_address: '1.0.0.1')
      url.add_view(view)
      # TODO: test that the view and urls were created
    end
  end
end