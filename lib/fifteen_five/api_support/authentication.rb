module FifteenFive
  module ApiSupport
    class Authentication < Faraday::Middleware
      KEY = "Authorization".freeze

      def initialize(app, token)
        @token = token
        super(app)
      end

      def call(env)
        unless env.request_headers[KEY]
          env.request_headers[KEY] = "Bearer #{@token}"
        end

        # TODO: Is there a more apt place to invoke this logger?
        # TODO: The whitespace on this logger is very Rails-centric. Is there
        # a better way?
        FifteenFive.logger.info("  FifteenFive Request => #{env.url}")

        @app.call(env)
      end
    end
  end
end
