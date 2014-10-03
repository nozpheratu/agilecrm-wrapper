require "spec_helper"

describe AgileCRM do
  describe "#configure" do
    before do
      @domain = "mydomain"
      @api_key = "xxx"
      @email = "rspec@example.com"
      AgileCRM.configure do |config|
        config.domain = @domain
        config.api_key = @api_key
        config.email = @email
      end
    end

    it "has a custom configuration" do
      expect(AgileCRM.configuration.domain).to match @domain
      expect(AgileCRM.configuration.api_key).to match @api_key
      expect(AgileCRM.configuration.email).to match @email
    end
  end
end