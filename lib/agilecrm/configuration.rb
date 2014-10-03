module AgileCRM
  class Configuration
    attr_accessor :domain, :api_key, :email

    def initialize
      @domain = ""
      @api_key = ""
      @email = ""
    end
  end
end
