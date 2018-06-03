module FifteenFive
  class Pulse < ApiResource
    # Associations
    belongs_to  :report
    belongs_to  :user
  end
end
