module Her
  module AssoicationPatch
    Her::Model::Associations::Association.class_eval do
      # The 15Five API is not entirely RESTful so we must patch associations.
      #
      # Instead of e.g. `has_many` associations looking for a RESTful
      # endpoint, we're calling the base path and appending the parent's ID.
      #
      # Example:
      #   user = FifteenFive::User.find(1)
      #   => GET: https://my.15five.com/api/public/user/1/
      #   => <FifteenFive::User id:1>
      #   user.reports
      #   => Original GET: https://my.15five.com/api/public/user/1/reports
      #   => Patched GET: https://my.15five.com/api/public/report/?user_id=1
      #   => [<FifteenFive::Report id:1 user_id:1>, ...]
      #
      # The original method that was patched can be found here:
      # => https://github.com/remiprev/her/blob/1702ab992f5f2abd7e1f816a459fdf491c6acd15/lib/her/model/associations/association.rb#L43-L55
      def fetch(opts = {})
        attribute_value = @parent.attributes[@name]
        return @opts[:default].try(:dup) if @parent.attributes.include?(@name) && (attribute_value.nil? || !attribute_value.nil? && attribute_value.empty?) && @params.empty?

        return @cached_result unless @params.any? || @cached_result.nil?
        return @parent.attributes[@name] unless @params.any? || @parent.attributes[@name].blank?
        return @opts[:default].try(:dup) if @parent.new?

        # BEGIN PATCH
        parent_key, parent_id = @parent.request_path.split("/")
        association_class_name = @opts[:class_name] ? @opts[:class_name] : "#{@name.to_s.singularize.classify}"
        association_class = "FifteenFive::#{association_class_name}".constantize
        path = build_association_path -> { "#{association_class.build_request_path("#{association_class.collection_path}?#{parent_key}_id=#{parent_id}")}" }
        # END PATCH

        @klass.get(path, @params).tap do |result|
          @cached_result = result unless @params.any?
        end
      end
    end
  end
end
