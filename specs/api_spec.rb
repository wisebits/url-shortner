require_relative './spec_helper'

describe 'Test root route' do 
  it 'should find the root route' do
    get '/'
    last_response.body.must_include 'Url Shortner'
    last_response.status.must_equal 200
  end
end