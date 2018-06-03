module FifteenFive
  module ApiSupport
    class Authentication < Faraday::Middleware
      KEY = "Authorization".freeze unless defined? KEY

      def initialize(app, token)
        @token = token
        super(app)
      end

      def call(env)
        unless env.request_headers[KEY]
          env.request_headers[KEY] = "Bearer #{@token}"
        end
        @app.call(env)
      end
    end
  end
end
