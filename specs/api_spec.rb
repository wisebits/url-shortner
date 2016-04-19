require_relative './spec_helper'

describe 'Test root route' do 
  it 'should find the root route' do
    get '/'
    last_response.body.must_include 'URL Shortner'
    last_response.status.must_equal 200
  end
end

describe 'URL resource calls' do
  before do
    Permission.dataset.delete
    Url.dataset.delete
    User.dataset.delete
    View.dataset.delete
  end

  describe 'Creating new URLs' do
    it 'HAPPY: should create a new unique URL' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { title: 'test', full_url: 'http://test.com', short_url: 'http://wisebits/bfdd' }.to_json
      post '/api/v1/urls/', req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create URLs with duplicate names' do
    	req_header = { 'CONTENT_TYPE' => 'application/json' }
    	req_body = { title: 'test', full_url: 'http://test.com', short_url: 'http://wisebits/bfdd' }.to_json
    	post '/api/v1/urls/', req_body, req_header
    	post '/api/v1/urls/', req_body, req_header
    	_(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Finding existing URLs' do
    it 'HAPPY: should find an existing URL' do
    	new_url = Url.create(title: 'test23', full_url: 'http://test23.com', short_url: 'http://wisebits/bfdd23')
    	get "/api/v1/urls/#{new_url.id}"
    	_(last_response.status).must_equal 200

    	results = JSON.parse(last_response.body)
    	_(results['data']['id']).must_equal new_url.id
    end

    it 'SAD: it should not find non-existent URLs' do
    	get "/api/v1/urls/#{invalid_id(Url)}"
    	_(last_response.status).must_equal 404
    end
  end

  describe 'Getting an index of existing URLs' do
    it 'HAPPY: should find list of existing URLs' do
      (1..5).each { |i| Url.create(title: "Project #{i}" ,full_url: "http://test#{i}.com", short_url: "http://wisebits/bfdd#{i}") }
      result = get '/api/v1/urls/'
      urls = JSON.parse(result.body)
      _(urls['data'].count).must_equal 5
    end
  end
end