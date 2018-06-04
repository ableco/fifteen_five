require "fifteen_five/version"

require "logger"

require "her"
# Patch the Her gem to account for non-RESTful associations in the 15Five API.
require_relative "fifteen_five/her/association_patch"

# API Support
require_relative "fifteen_five/api_support/authentication"
require_relative "fifteen_five/api_support/response_parser"

module FifteenFive
  # When set prompts the library to log some extra information to $stdout and
  # $stderr about what it's doing. For example, it'll produce information about
  # requests, responses, and errors that are received. Valid log levels are
  # `debug` and `info`, with `debug` being a little more verbose in places.
  #
  # Use of this configuration is only useful when `.logger` is _not_ set. When
  # it is, the decision what levels to print is entirely deferred to the logger.
  def self.log_level
    @log_level
  end

  def self.log_level=(val)
    if !val.nil? && ![Logger::DEBUG, Logger::ERROR, Logger::INFO].include?(val)
      raise ArgumentError, "log_level should only be set to `nil`, `debug` or `info`"
    end
    @log_level = val
  end
  @log_level = nil

  # Sets a logger to which logging output will be sent. The logger should
  # support the same interface as the `Logger` class that's part of Ruby's
  # standard library (hint, anything in `Rails.logger` will likely be
  # suitable).
  #
  # If `.logger` is set, the value of `.log_level` is ignored. The decision on
  # what levels to print is entirely deferred to the logger.
  def self.logger
    @logger
  end

  def self.logger=(val)
    @logger = val
  end
  @logger = nil

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def self.setup(token)
    Her::API.setup url: "https://my.15five.com/api/public/" do |c|
      # Request
      c.use FifteenFive::ApiSupport::Authentication, token

      # Response
      c.use FifteenFive::ApiSupport::ResponseParser

      # Adapter
      c.use Faraday::Adapter::NetHttp
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
    load File.join(File.dirname(__FILE__), "fifteen_five", "answer.rb")
    load File.join(File.dirname(__FILE__), "fifteen_five", "bulk_user_import.rb")
    load File.join(File.dirname(__FILE__), "fifteen_five", "department.rb")
    load File.join(File.dirname(__FILE__), "fifteen_five", "group.rb")
    load File.join(File.dirname(__FILE__), "fifteen_five", "hello.rb")
    load File.join(File.dirname(__FILE__), "fifteen_five", "high_five.rb")
    load File.join(File.dirname(__FILE__), "fifteen_five", "objective.rb")
    load File.join(File.dirname(__FILE__), "fifteen_five", "question.rb")
    load File.join(File.dirname(__FILE__), "fifteen_five", "pulse.rb")
    load File.join(File.dirname(__FILE__), "fifteen_five", "report.rb")
    load File.join(File.dirname(__FILE__), "fifteen_five", "security_audit.rb")
    load File.join(File.dirname(__FILE__), "fifteen_five", "user.rb")
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end
