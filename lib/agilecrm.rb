require 'faraday'
require 'faraday_middleware'
require 'agilecrm/version'
require 'agilecrm/configuration'
require 'agilecrm/contact'
require 'agilecrm/response/raise_error'

module AgileCRM
  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def reset
      @configuration = Configuration.new
    end

    def configure
      yield(configuration)
    end

    def endpoint
      "https://#{configuration.domain}.agilecrm.com/dev/api"
    end

    def connection
      @connection ||= default_connection
      return @connection
    end

    def default_connection
      options = {
        headers: { 'Accept' => 'application/json' }
      }
      Faraday.new(endpoint, options) do |conn|
        conn.request :json
        conn.request :basic_auth, configuration.email, configuration.api_key
        conn.response :json, content_type: /\bjson$/
        conn.response :agilecrm_error
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
