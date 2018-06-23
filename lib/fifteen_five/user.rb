module FifteenFive
  class User < ApiResource
    # Associations
    belongs_to  :reviewer, class_name: "User"
    has_many    :answers
    has_many    :groups
    has_many    :high_fives, class_name: "HighFive"
    has_many    :pulses
    has_many    :questions
    has_many    :reports
    has_many    :reviewed_reports, as: :reviewer
  end
end
