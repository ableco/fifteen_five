require "her"
require "fifteen_five/version"

# Authentication
require_relative "fifteen_five/authentication"

# API resource support
require_relative "fifteen_five/response_parser"

module FifteenFive
  # TODO: Resolve deprecation warning:
  #   > WARNING: Unexpected middleware set after the adapter. This won't be
  #   > supported from Faraday 1.0.
  def self.setup(token)
    Her::API.setup url: "https://my.15five.com/api/public/" do |c|
      # Request
      c.use FifteenFive::Authentication, token
      c.use Faraday::Request::UrlEncoded

      # Response
      c.use FifteenFive::ResponseParser

      # Adapter
      c.use Faraday::Adapter::NetHttp
      c.use Her::Middleware::AcceptJSON
    end

    # TODO: These really should be `require_relative` statements but, due to
    # some internal implementation issues in Her, we can't call
    # `include Her::Model` before `Her::API.setup` has been called. This is
    # not great for a variety of reasons:
    #
    # - obfuscation of dependencies
    # - syntax nastiness
    # - danger of `setup` getting called twice (classes will be loaded again)
    # - can't take advantage of autoloading in dev/test
    #
    # See: https://github.com/remiprev/her/issues/202
    #
    # API resource support
    load File.join(File.dirname(__FILE__), "fifteen_five", "api_resource.rb")
    #
    # Named API resources
    load File.join(File.dirname(__FILE__), "fifteen_five", "group.rb")
    load File.join(File.dirname(__FILE__), "fifteen_five", "report.rb")
    load File.join(File.dirname(__FILE__), "fifteen_five", "user.rb")
  end
end
