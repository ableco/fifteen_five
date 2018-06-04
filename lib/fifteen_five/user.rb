module FifteenFive
  class User < ApiResource
    # Associations
    has_many :reports
    has_many :groups
  end
end
