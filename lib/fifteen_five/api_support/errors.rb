module FifteenFive
  module ApiSupport
    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
      class Unknown < StandardError; end
    end
  end
end
