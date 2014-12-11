require 'spec_helper'

describe AgileCRMWrapper do
  let(:domain) { 'mydomain' }
  let(:api_key) { 'xxx' }
  let(:email) { 'email@example.com' }

  describe 'configuration' do
    before(:each) do
      AgileCRMWrapper.configure do |config|
        config.domain = domain
        config.api_key = api_key
        config.email = email
      end
    end

    after :each do
      AgileCRMWrapper.reset
    end

    describe '.configure' do
      it 'has a custom configuration' do
        expect(AgileCRMWrapper.configuration.domain).to match domain
        expect(AgileCRMWrapper.configuration.api_key).to match api_key
        expect(AgileCRMWrapper.configuration.email).to match email
      end

      its(:endpoint) { should eq 'https://mydomain.agilecrm.com/dev/api' }
    end

    describe '.reset' do
      before(:each) do
        AgileCRMWrapper.configure do |config|
          config.email = email
        end
      end

      it 'resets the configuration' do
        AgileCRMWrapper.reset
        config = AgileCRMWrapper.configuration
        expect(config.email).to eq ''
      end
    end
  end
end
