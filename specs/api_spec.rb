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
    Privacy.dataset.delete
    Url.dataset.delete
    User.dataset.delete
    View.dataset.delete
  end

  describe 'Creating new URLs' do
    it 'HAPPY: should create a new unique URL' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { title: 'Test URL' }.to_json
      post 'api/v1/urls/', req_body, req_header
      _(last_response.status).must_equal 302
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create URLs with duplicate names' do
    	req_header = { 'CONTENT_TYPE' => 'application/json' }
    	req_body = { title: 'Test URL' }.to_json
    	post '/api/v1/urls/', req_body, req_header
    	post '/api/v1/urls/', req_body, req_header
    	_(last_response.status).must_equal 400
  end

  describe 'Finding existing URLs' do
    it 'HAPPY: should find an existing URL' do
    	new_url = Url.new(title: 'test url')
    	get "/api/v1/urls/#{new_url.id}"
    	_(last_response.status).must_equal 200
    	results = JSON.parse(last_response.body)
    	_(results['id']).must_equal new_url.body
    end

    it 'SAD: it should not find non-existent URLs' do
    	get "/api/v1/urls/#{rand(1..1000)}"
    	_(last_response.status).must_equal 404
    end
  end
end