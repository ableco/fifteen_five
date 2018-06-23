require "yaml"
require_relative "errors"

module FifteenFive
  module ApiSupport
    class ResponseParser < Faraday::Response::Middleware
      API_BASE_URI = "https://my.15five.com/api/public/".freeze
      ATTRIBUTE_KEY_MAP = YAML.load_file(File.join(__dir__, "attribute_map.yml")).freeze

      def on_complete(env)
        json = parse_json(env[:body])

        case env[:status]
        when 200
          env[:body] = on_success(json)
        else
          on_error(env[:status])
        end
      end

      private

      def parse_json(raw_json)
        MultiJson.load(raw_json, symbolize_keys: true)
      rescue MultiJson::ParseError
        nil
      end

      def on_success(json) # rubocop:disable Metrics/MethodLength
        # If there's a :results key, that means we got an array back.
        if json.key?(:results)
          data = parse_data(json.delete(:results) || json)
          metadata = json
        else
          data = parse_data(json)
          metadata = {}
        end

        {
          data: data,
          errors: [],
          metadata: metadata
        }
      end

      def on_error(status_code)
        case status_code
        when 403
          raise FifteenFive::ApiSupport::Errors::Unauthorized, "Unauthorized."
        when 404
          raise FifteenFive::ApiSupport::Errors::NotFound, "Not found."
        else
          raise FifteenFive::ApiSupport::Errors::Unknown, "Unknown error."
        end
      end

      def parse_data(unformatted_data)
        if unformatted_data.is_a?(Array)
          unformatted_data.map { |object| format_data(object) }
        else
          format_data(unformatted_data)
        end
      end

      # Format unformatted API data into a format that's expected by Her.
      #
      # Attributes:
      #   unformatted_data: Hash of data coming from the 15Five API.
      #
      # Return Hash of API data with keys and values that we expect.
      def format_data(unformatted_data)
        formatted_data = {}

        unformatted_data.each_pair do |unformatted_key, unformatted_value|
          formatted_key = format_key(unformatted_key)
          formatted_data[formatted_key] = format_value(unformatted_value)
        end

        formatted_data
      end

      def format_key(unformatted_key)
        ATTRIBUTE_KEY_MAP[unformatted_key.to_s] || unformatted_key.to_s
      end

      def format_value(unformatted_value)
        if resource_url?(unformatted_value)
          extract_id_from_resource_url(unformatted_value)
        elsif unformatted_value.is_a?(Array) && resource_url?(unformatted_value.first)
          unformatted_value.map { |item| extract_id_from_resource_url(item) }
        else
          unformatted_value
        end
      end

      def resource_url?(unformatted_value)
        unformatted_value.is_a?(String) && unformatted_value.match?(API_BASE_URI)
      end

      # Convert FifteenFive associations references from URLs to IDs.
      #
      # Examples:
      #
      #   "https://my.15five.com/api/public/user/123/" => 123
      #   "https://my.15five.com/api/public/user/456/" => 456
      #
      # Return Integer ID at the end of the resource URL.
      def extract_id_from_resource_url(resource_url)
        resource_url.split("/").last.to_i
      end
    end
  end
end
