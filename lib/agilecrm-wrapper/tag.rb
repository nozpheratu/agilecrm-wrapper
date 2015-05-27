require 'agilecrm-wrapper/error'
require 'hashie'

module AgileCRMWrapper
  class Tag < Hashie::Mash
    class << self

      ##
      # Get all tags
      # `AgileCRMWrapper::Tag.all`

      def all
        response = AgileCRMWrapper.connection.get('tags')
        if response.status == 200
          return response.body.map { |body| new body }
        else
          return response
        end
      end
    end
  end
end
