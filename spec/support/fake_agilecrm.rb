# http://robots.thoughtbot.com/how-to-stub-external-services-in-tests
require 'sinatra/base'

class FakeAgileCRM < Sinatra::Base
  get '/dev/api/contacts' do
    json_response 200, 'contacts', 'list_contacts'
  end

  get '/dev/api/contacts/:id' do
    if params[:id] == '0'
      status 204
    else
      json_response 200, 'contacts', 'get_contact'
    end
  end

  get '/dev/api/contacts/:id/notes' do
    json_response 200, 'contacts', 'get_contact_notes'
  end

  post '/dev/api/contacts/search/email' do
    if JSON.parse(params['email_ids']).include? 'anitadrink@example.com'
      json_response 200, 'contacts', 'search_by_email'
    elsif JSON.parse(params['email_ids']).include? 'idontexist@example.com'
      json_response 200, 'contacts', 'search_by_email_no_results'
    end
  end

  post '/dev/api/notes' do
    json_response 200, 'notes', 'create_note'
  end

  post '/dev/api/contacts' do
    json_response 201, 'contacts', 'create_contact'
  end

  post '/dev/api/contacts/bulk/tags' do
    status 200
  end

  put '/dev/api/contacts' do
    json_response 200, 'contacts', 'updated_contact'
  end

  delete '/dev/api/contacts/:id' do
    status 204
  end

  private

  def json_response(response_code, resource, file_name)
    content_type :json
    status response_code
    File.read(
      File.expand_path(
        "spec/fixtures/#{resource}/#{file_name}.json",
        Dir.pwd
      )
    )
  end
end
