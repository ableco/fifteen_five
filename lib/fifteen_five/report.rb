module FifteenFive
  class Report < ApiResource
    # Associations
    belongs_to  :reviewer, class_name: "User"
    belongs_to  :user
    has_many    :high_fives, class_name: "HighFive"
  end
end
