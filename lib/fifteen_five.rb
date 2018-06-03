require "fifteen_five/version"

require "her"
# Patch the Her gem to account for non-RESTful associations in the 15Five API.
require_relative "fifteen_five/her/association_patch"

# API Support
require_relative "fifteen_five/api_support/authentication"
require_relative "fifteen_five/api_support/response_parser"

module FifteenFive
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
