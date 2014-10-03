require "json"

module AgileCRM
  class Request
    attr_accessor :http_method, :resource, :data

    VALID_HTTP_METHODS = [:get, :post, :put, :delete]

    VALID_RESOURCES = ["contacts"] # will support "tags", "score", "note", "task", "deal" later

    def initialize(http_method, resource, data = {})
      @http_method = http_method
      @resource = resource
      @data = data
      raise "Unknown HTTP Method #{@http_method} - expected one of #{VALID_HTTP_METHODS.join(', ')}" unless VALID_HTTP_METHODS.include? @http_method.to_sym
      raise "Unknown Resource #{@resource} - expected one of #{VALID_RESOURCES.join(', ')}" unless VALID_RESOURCES.include? @resource
    end

    def dispatch
      case http_method
      when :get
        request = Net::HTTP::Get.new("/dev/api/#{resource}", initheader = {"Accept" => 'application/json'} )
      when :post
        request = Net::HTTP::Post.new("/dev/api/#{resource}")
        request.body = data.to_json
      end
      uri = URI.parse(endpoint)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request["Content-Type"] = 'application/json'
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request.basic_auth AgileCRM.configuration.email, AgileCRM.configuration.api_key
      response = http.request(request)
      JSON.parse(response.body)
    end

    private

    def endpoint
      "https://#{AgileCRM.configuration.domain}.agilecrm.com"
    end
  end
end