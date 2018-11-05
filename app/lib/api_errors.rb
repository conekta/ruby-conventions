module ApiErrors

  LEVELS = {
    warning: 'warning',
    error: 'error'
  }

  class ApiError < StandardError
    attr_reader :level, :message, :data, :status


    def initialize(level, message, data = nil, status = nil)
      super(message)
      @level = ApiErrors::LEVELS[level] || ApiError::LEVELS[:error]
      @status = status || 500
      @message = message
      @data = data
    end
  end

  class AuthenticationError < ApiError
    def initialize(message, data = nil)
      super(:warning, message, data, 401)
    end
  end

  class AuthorizationError < ApiError
    def initialize(message, data = nil)
      super(:warning, message, data, 403)
    end
  end

  class InternalServerError < ApiError
    def initialize(message, data = nil)
      super(:error, message, data, 500)
    end
  end

  class BadGatewayError < ApiError
    def initialize(message, data = nil)
      super(:error, message, data, 502)
    end
  end

  class BadRequestError < ApiError
    def initialize(message, data = nil)
      super(:warning, message, data, 400)
    end
  end

  class UnprocessableEntityError < ApiError
    def initialize(message, data = nil)
      super(:warning, message, data, 422)
    end
  end

  class NotFoundError < ApiError
    def initialize(message, data = nil)
      super(:warning, message, data, 404)
    end
  end

end
