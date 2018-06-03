module FifteenFive
  class User < ApiResource
    # Associations
    has_many :reports
  end
end
