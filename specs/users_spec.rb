require_relative './spec_helper' 

describe 'Testing User resource routes' do 
	before do
		Permission.dataset.delete
		Url.dataset.delete
		User.dataset.delete
		View.dataset.delete
	end

	describe 'Creating new user' do
		it 'HAPPY: should create a new unique user' do
			req_header = { 'CONTENT_TYPE' => 'application/json' }
			req_body = { username: 'wisebits', email: 'test@wisebits.com', password: 'mypassword' }.to_json
			post '/api/v1/users/', req_body, req_header
			_(last_response.status).must_equal 201
			_(last_response.location).must_match(%r{http://})
		end

		it 'SAD: should not create users with duplicate usernames' do
			req_header = { 'CONTENT_TYPE' => 'application/json' }
			req_body = { username: 'wisebits', email: 'test@wisebits.com', password: 'mypassword' }.to_json
			post '/api/v1/users/', req_body, req_header
			post '/api/v1/users/', req_body, req_header
			_(last_response.status).must_equal 400
			_(last_response.location).must_be_nil
		end
	end

	describe 'Testing unit level properties of users' do
		before do
			@original_password = 'mypassword'
			@user = CreateNewUser.call(
				username: 'wisebits',
				email: 'test@wisebits.com',
				password: '@original_password')
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
			new_user = CreateNewUser.call(
				username: 'wisebits',
				email: 'test@wisebits.com',
				password: 'mypassword')

			new_urls = (1..3).map do |i|
				CreateNewUrl.call(
					title: 'test#{i}',
					full_url: 'http://test#{i}.com',
					description: 'Test #{i}')
			end

			new_urls.each do |url|
				new_user.add_owned_url(url)
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

	describe 'Creating new URL for user owner' do
		before do
			@user = CreateNewUser.call(
				username: 'wisebits',
				email: 'test@wisebits.com',
				password: 'mypassword')
		end

		it 'HAPPY: should create a new unique URL for user' do
			req_header = { 'CONTENT_TYPE' => 'application/json' }
	      req_body = { title: 'test', full_url: 'http://test.com', short_url: 'http://wisebits/bfdd' }.to_json
	      post '/api/v1/users/#{@user.username}/urls/', req_body, req_header
	      _(last_response.status).must_equal 201
	      _(last_response.location).must_match(%r{http://})
		end

		it 'SAD: should not create URLs with duplicate names' do
			req_header = { 'CONTENT_TYPE' => 'application/json' }
	      req_body = { title: 'test', full_url: 'http://test.com', short_url: 'http://wisebits/bfdd' }.to_json
	      post '/api/v1/users/#{@user.username}/urls/', req_body, req_header
	      post '/api/v1/users/#{@user.username}/urls/', req_body, req_header
	      _(last_response.status).must_equal 400
	      _(last_response.location).must_be_nil
		end

		it 'HAPPY: should encrypt all relevant data' do

		end
	end

	describe 'Get index of all URLs for a user' do
		it 'HAPPY: should find all URLs for a user' do
			my_user = CreateNewUser.call(
				username: 'wisebits',
				email: 'test@wisebits.com',
				password: 'mypassword')

			my_urls = (1..3).map do |i|
				CreateNewUrl.call(
					title: 'test#{i}',
					full_url: 'http://test#{i}.com',
					description: 'Test #{i}')
			end

			my_urls.each do |url|
				my_user.add_owned_url(url)
			end

			result = get "/api/v1/users/#{my_user.username}/urls"
			_(result.status).must_equal 200
			urls = JSON.parse(result.body)
			_(urls['data'].count).must_equal 5
		end
	end
end