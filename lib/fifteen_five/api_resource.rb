module FifteenFive
  class ApiResource
    include Her::Model

    def self.inherited(klass)
      resource_name = klass.name.demodulize.downcase
      klass.collection_path("#{resource_name}/")
      klass.resource_path("#{resource_name}/:id/")
    end

    def extract_id_from(attribute)
      if attribute.is_a?(Array)
        attribute.map { |url| extract_id_from_resource_url(url) }
      else
        extract_id_from_resource_url(attribute)
      end
    end
    alias extract_ids_from extract_id_from

    private

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
