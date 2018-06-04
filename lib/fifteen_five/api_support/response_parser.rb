require_relative "errors"

module FifteenFive
  module ApiSupport
    class ResponseParser < Faraday::Response::Middleware
      def on_complete(env)
        json = parse_json(env[:body])

        case env[:status]
        when 200
          env[:body] = on_success(json)
        when 403, 404
          on_error(env[:status], json)
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

      def on_error(status_code, json)
        case status_code
        when 403
          raise FifteenFive::ApiSupport::Errors::Unauthorized, json[:detail]
        when 404
          raise FifteenFive::ApiSupport::Errors::NotFound, "Not found."
        else
          raise FifteenFive::ApiSupport::Errors::Unknown, "Unknown Error."
        end
      end

      def parse_data(data)
        if data.is_a?(Array)
          data.map { |object| convert_resource_urls_to_ids(object) }
        elsif data.is_a?(Hash)
          convert_resource_urls_to_ids(data)
        end
      end

      # TODO: Refactor to reduce branch complexity. This method should probably
      # use a simple key map to massage the keys into something Her can
      # understand.
      def convert_resource_urls_to_ids(data)
        data_with_converted_ids = {}

        data.each_pair do |key, value|
          if resource_url?(value)
            # TODO: Here are some hacks to catch for various inconsistencies
            # in the 15Five API key names :(
            # => Report#reviwer
            if key == :reviewed_by
              key = "reviewer_id"
            else
              key = "#{key}_id" unless key.match?("_id")
            end
            data_with_converted_ids[key] = extract_id_from_resource_url(value)
          elsif value.is_a?(Array) && resource_url?(value.first)
            key = "#{key.to_s.singularize}_ids" unless key.match?("_ids")
            data_with_converted_ids[key] = value.map do |item|
              extract_id_from_resource_url(item)
            end
          else
            # TODO: Here are some hacks to catch for various inconsistencies
            # in the 15Five API key names :(
            # => SecurityAudit#actor
            # => Report#groups
            key = case key
                  when :actor
                    "actor_id"
                  when :company_groups_ids
                    "group_ids"
                  else
                    key
                  end
            data_with_converted_ids[key.to_s] = value
          end
        end

        data_with_converted_ids
      end

      def resource_url?(value)
        value.is_a?(String) && value.match?("https://my.15five.com/api/public/")
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
