# http://robots.thoughtbot.com/how-to-stub-external-services-in-tests
require 'sinatra/base'

class FakeAgileCRM < Sinatra::Base

  get '/dev/api/contacts' do
    json_response 200, 'list_contacts'
  end

  get '/dev/api/contacts/:id' do
    if params[:id] == "0"
      status 204
    else
      json_response 200, 'get_contact'
    end
  end

  post '/dev/api/contacts' do
    json_response 201, 'create_contact'
  end

  post '/dev/api/contacts/bulk/tags' do
    status 200
  end

  delete '/dev/api/contacts/:id' do
    status 204
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.read(File.expand_path("spec/fixtures/#{file_name}.json", Dir.pwd))
  end
end
