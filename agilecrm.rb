require "net/http"
require "uri"
require 'json'

class AgileCRM
  class << self
    def api_key=(key)
      @@api_key = key
    end

    def domain=(d)
      @@domain = d
    end

    def api_key
      @@api_key
    end

    def domain
      @@domain
    end

    def request(method, subject, data = {})
      path = "/core/php/api/#{subject}?id=#{api_key}"
      email = data[:email] || data['email']
      case method
      when :get
        path += "&email=#{email}"
        request = Net::HTTP::Get.new(path)
      when :post
        request = Net::HTTP::Post.new(path)
        request.body = data.to_json
      when :put
        request = Net::HTTP::Put.new(path)
        request.body = data.to_json
      when :delete
        path += "&email=#{email}"
        request = Net::HTTP::Delete.new(path)
      else
        raise "Unknown method: #{method}"
      end
      uri = URI.parse("https://#{domain}.agilecrm.com")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request["Content-Type"] = 'application/json'
      response = http.request(request)
      JSON.parse(response.body)
    end
  end
end
