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
    before do
      @registration_data = {
        username: 'bob',
        password: 'mypassword',
        email: 'bob@gmail.com'}
      @req_body = client_signed(@registration_data)
    end

    it 'HAPPY: should create a new unique user' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/users/',@req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create users with duplicate usernames' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/users/', @req_body, req_header
      post '/api/v1/users/', @req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
      end
    end

    it 'BAD: should not create user unless requested from the authorized app' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = @registration.to_json
      post '/api/v1/users/', req_body, req_header
      post '/api/v1/users/', req_body, req_header
      _(last_response.status).must_equal 401
      _(last_response.location).must_be_nil
    end

  describe 'Testing unit level properties of users' do
    before do
      @original_password = 'mypassword'
      @user = create_client_user(
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
    before do
      @new_user = create_client_user(
        username: 'alice',
        email: 'alice@gmail.com',
        password: 'mypassword')

      @new_urls = (1..3).map do |i|
        @new_user.add_owned_url(CreateUrl.call(
          full_url: "https://aliceinwonderland#{i}.com",
          description: "Alice in Wonderland",
          title: "A world of wonders" 
          ))
      end

      @auth_token = authorized_user_token(
        username: 'alice',
        password: 'mypassword')
    end

    it 'HAPPY: should find an existing user' do
      get "/api/v1/users/#{@new_user.id}", nil, { "HTTP_AUTHORIZATION" => "Bearer #{@auth_token}" }
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)   
      _(results['data']['id']).must_equal @new_user.id
      3.times do |i|
        _(results['relationships'][i]['id']).must_equal @new_urls[i].id
      end
    end

    it 'SAD: should not return wrong user' do
      get "/api/v1/users/#{random_str(10)}", nil, { "HTTP_AUTHORIZATION" => "Bearer #{@auth_token}" }
      _(last_response.status).must_equal 401
    end

    it 'SAD: should not return user without authorization' do
      get "/api/v1/users/#{@new_user.id}"
      _(last_response.status).must_equal 401
    end
  end

  describe  'Authenticating an account' do
    def login_with(username:, password:, client_auth: true)
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      credentials = { username: username, password: password }.to_json

      if client_auth
        app_secret_key = JOSE::JWK.from_okp([:Ed25519, Base64.decode64(ENV['APP_SECRET_KEY'])])
        req_body = app_secret_key.sign(credentials).compact
      else
        req_body = nil
      end

      post '/api/v1/users/authenticate', req_body, req_header
    end

    before do
      @user = create_client_user(
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

    it 'BAD: should not authenticate valid credentials user without client app authorization' do
      login_with(username: 'alice', password: 'mypassword', client_auth: false)
      _(last_response.status).must_equal 401
    end
  end
end