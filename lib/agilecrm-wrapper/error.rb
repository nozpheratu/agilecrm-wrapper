module AgileCRMWrapper
  class Error < StandardError
    attr_reader :response

    class << self
      def from_response(response, message = '')
        new(response, message)
      end

      def errors
        @errors ||= {
          400 => AgileCRMWrapper::BadRequest,
          401 => AgileCRMWrapper::Unauthorized,
          404 => AgileCRMWrapper::NotFound,
          405 => AgileCRMWrapper::MethodNotAllowed,
          415 => AgileCRMWrapper::MediaTypeMismatch,
          500 => AgileCRMWrapper::InternalServerError
        }
      end
    end

    def initialize(response, message = '')
      super(message)
      @response = response
    end
  end

  # Raised when Twitter returns a 4xx HTTP status code
  class ClientError < Error; end

  # Raised when AgileCRMWrapper returns a 400 HTTP status code
  class BadRequest < ClientError
    def initialize(response, message = 'The request was formatted incorrectly')
      super(response, message)
    end
  end

  # Raised when AgileCRMWrapper returns a 401 HTTP status code
  class Unauthorized < ClientError
    def initialize(response, message = 'Invalid API Key')
      super(response, message)
    end
  end

  # Raised when AgileCRMWrapper returns a 404 HTTP status code
  class NotFound < ClientError
    def initialize(response, message = 'Resource not found')
      super(response, message)
    end
  end

  # Raised when AgileCRMWrapper returns a 405 HTTP status code
  class MethodNotAllowed < ClientError
    def initialize(response, message = 'Invalid method type')
      super(response, message)
    end
  end

  # Raised when AgileCRMWrapper returns a 415 HTTP status code
  class MediaTypeMismatch < ClientError
    def initialize(response, message = 'Unsupported Media type')
      super(response, message)
    end
  end

  # Raised when AgileCRMWrapper returns a 5xx HTTP status code
  class ServerError < Error; end

  # Raised when AgileCRMWrapper returns a 500 HTTP status code
  class InternalServerError < ServerError
    def initialize(response, message = 'Server error')
      super(response, message)
    end
  end
end
