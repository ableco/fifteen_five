module FifteenFive
  class Report < ApiResource
    # Associations
    belongs_to :user
    belongs_to :reviewer, class_name: "User"
  end
end
