require "agilecrm/version"
require "agilecrm/configuration"
require "agilecrm/request"

begin
  require "pry"
rescue LoadError
end

module AgileCRM
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end