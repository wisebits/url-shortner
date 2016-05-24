require_relative './spec_helper' 

describe 'Testing User resource routes' do 
  # clean datasets
  before do
    Permission.dataset.destroy
    Url.dataset.destroy
    User.dataset.destroy
    View.dataset.destroy
  end

  describe 'Creating new user' do
    it 'HAPPY: should create a new unique user' do
    req_header = { 'CONTENT_TYPE' => 'application/json' }
    req_body = { username: 'bob', email: 'bob@gmail.com', password: 'mypassword' }.to_json
    post '/api/v1/users/', req_body, req_header
    _(last_response.status).must_equal 201
    _(last_response.location).must_match(%r{http://})
  end

  it 'SAD: should not create users with duplicate usernames' do
    req_header = { 'CONTENT_TYPE' => 'application/json' }
    req_body = { username: 'bob', email: 'bob@gmail.com', password: 'mypassword' }.to_json
    post '/api/v1/users/', req_body, req_header
    post '/api/v1/users/', req_body, req_header
    _(last_response.status).must_equal 400
    _(last_response.location).must_be_nil
    end
  end

  describe 'Testing unit level properties of users' do
    before do
      @original_password = 'mypassword'
      @user = CreateUser.call(
        username: 'alice',
        email: 'alice@gmail.com',
        password: @original_password)
    end

    it 'HAPPY: should hash the password' do
      _(@user.password_hash).wont_equal @original_password
    end

    it 'HAPPY: should re-salt the password' do
      hashed = @user.password_hash
      @user.password = @original_password
      @user.save
      _(@user.password_hash).wont_equal hashed
    end
  end

  describe 'Finding an existing user' do
    it 'HAPPY: should find an existing user' do
      new_user = CreateUser.call(
        username: 'alice',
        email: 'alice@gmail.com',
        password: 'mypassword')

      new_urls = (1..3).map do |i|
        new_user.add_owned_url(CreateUrl.call(
          full_url: "https://aliceinwonderland#{i}.com",
          description: "Alice in Wonderland",
          title: "A world of wonders" 
          ))
      end  

      get "/api/v1/users/#{new_user.username}"
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
     
      _(results['data']['username']).must_equal new_user.username
      3.times do |i|
        _(results['relationships'][i]['id']).must_equal new_urls[i].id
      end
    end

    it 'SAD: should not find non-existent user' do
      get "/api/v1/users/#{random_str(10)}"
      _(last_response.status).must_equal 404
    end
  end

  describe 'Creating new owned URL for user owner' do
    before do
      @user = CreateUser.call(
        username: 'alice',
        email: 'alice@gmail.com',
        password: 'mypassword')
    end
    
    it 'HAPPY: should create a new owned URL for user' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { title: 'test', full_url: 'http://test.com', description: 'testings' }.to_json
      post "/api/v1/users/alice/owned_urls/", req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create URLs with duplicate names' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { title: 'test', full_url: 'http://test.com', description: 'testings' }.to_json
      2.times do
        post "/api/v1/users/alice/owned_urls/", req_body, req_header
      end
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end

    it 'HAPPY: should create additional information (e.g., views)' do
      url = CreateUrlForOwner.call(
        user: @user,
        full_url: "https://aliceinwonderland.com",
        title: "A world of wonders",
        description: "Alice in Wonderland",)
      view = CreateView.call(location: 'Wonderland', ip_address: '1.0.0.1')
      url.add_view(view)
      # TODO: test that the view and urls were created
    end
  end

  describe  'Authenticating an account' do
    def login_with(username:, password:)
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { username: username, password: password }.to_json
      post '/api/v1/users/authenticate', req_body, req_header
    end

    before do
      @user = CreateUser.call(
        username: 'alice',
        email: 'alice@gmail.com',
        password: 'mypassword')
    end

    it 'HAPPY: should be able to authenticate a real user account' do
      login_with(username: 'alice', password: 'mypassword')
      _(last_response.status).must_equal 200
      response = JSON.parse(last_response.body)
      _(response['user']).wont_equal nil 
      _(response['auth_token']).wont_equal nil
    end

    it 'SAD: should not authenticate a user with wrong password' do
      login_with(username: 'alice', password: 'guess.password')
      _(last_response.status).must_equal 401
    end

    it 'SAD: should not authenticate a user with an invalid username' do
      login_with(username: 'randomuser', password: 'mypassword')
      _(last_response.status).must_equal 401
    end

    it 'BAD: should not authenticate a user without password' do
      login_with(username: 'alice', password: '')
      _(last_response.status).must_equal 401
    end
  end
end