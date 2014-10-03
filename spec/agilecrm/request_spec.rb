require "spec_helper"
require "webmock/rspec"
require "json"

describe AgileCRM::Request do
  let(:contact_data) {
    {
      tags: ["lead"],
      properties: [
        { type: "SYSTEM", name: "first_name", value: "Luke" },
        { type: "SYSTEM", name: "last_name",  value: "Warm" },
        { type: "SYSTEM", name: "email", subtype: "work", value: "lukewarm@example.com" }
      ]
    }
  }
  let(:http_method) { :post }
  let(:resource) { "contacts" }
  let(:request) { AgileCRM::Request.new(http_method, resource, contact_data) }

  describe "#new" do
    subject { AgileCRM::Request.new(http_method, resource, {}) }

    context "given an invalid HTTP method" do
      let(:http_method) { :foo_http_method }

      it { expect{subject}.to raise_error }
    end

    context "given an invalid resource" do
      let(:resource) { "foo resource" }

      it { expect{subject}.to raise_error }
    end

    context "given valid arguments" do
      it { expect{subject}.not_to raise_error }
    end
  end

  describe "#dispatch" do
    before do
      @domain = "xyzcompany"
      @api_key = "xxxxx"
      @email = "rspec"
      AgileCRM.configure do |config|
        config.domain = @domain
        config.api_key = @api_key
        config.email = @email
      end
    end

    context "get" do
      let(:http_method) { :get }

      context "contacts" do
        before do
          @res = JSON.parse(File.read(File.expand_path("spec/fixtures/list_contacts.json", Dir.pwd)))

          stub_request(:get, "https://rspec:xxxxx@xyzcompany.agilecrm.com/dev/api/contacts").with(
            :headers => {
              'Accept'=>'application/json',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type'=>'application/json',
              'User-Agent'=>'Ruby'
          }).to_return(:status => 200, :body => @res.to_json, :headers => {})
        end

        it { expect(request.dispatch).to eq(@res) }
      end
    end

    context "post" do
      let(:http_method) { :post }

      context "contacts" do
        before do
          @res = JSON.parse(File.read(File.expand_path("spec/fixtures/get_contact.json", Dir.pwd)))

          stub_request(:post, "https://rspec:xxxxx@xyzcompany.agilecrm.com/dev/api/contacts").with(
            :body => contact_data,
            :headers => {
              'Accept'=>'*/*',
              'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type'=>'application/json',
              'User-Agent'=>'Ruby'
          }).to_return(:status => 200, :body => @res.to_json, :headers => {})
        end

        it { expect(request.dispatch).to eq(@res) }
      end
    end
  end
end
