require 'faraday'
require 'agilecrm-wrapper/error'

module AgileCRMWrapper
  module Response
    class RaiseError < Faraday::Response::Middleware
      private

      def on_complete(response)
        status_code = response.status.to_i
        klass = AgileCRMWrapper::Error.errors[status_code]
        return unless klass
        fail(klass.from_response(response))
      end
    end
  end
end

Faraday::Response.register_middleware(
  agilecrm_error: AgileCRMWrapper::Response::RaiseError
)
