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
      new_url = Url.new(title: 'test23')
      new_url.url = 'http://test23.com'
      new_url.shorturl = new_url.url
      new_url.save

      #new_permissions = (1..3).map do |i|
      #new_url.add_permission(status: 'testing', description: 'anything')
      #end

      get "/api/v1/urls/#{new_url.id}"
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['data']['id']).must_equal new_url.id

      #3.times do |i|
      #  _(results['relationships'][i]['id']).must_equal new_permissions[i].id
      #end
    end

    it 'SAD: it should not find non-existent URLs' do
      get "/api/v1/urls/#{invalid_id(Url)}"
      _(last_response.status).must_equal 404
    end
  end

  describe 'Getting an index of existing URLs' do
    it 'HAPPY: should find list of existing URLs' do
      (1..5).each do |i|
        new_url = Url.new(title: 'test')
        new_url.url = "http://test#{i}.com"
        new_url.shorturl = new_url.url
        new_url.save
      end 

      result = get '/api/v1/urls/'
      urls = JSON.parse(result.body)
      _(urls['data'].count).must_equal 5
    end
  end
end