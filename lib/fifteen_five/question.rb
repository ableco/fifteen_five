module FifteenFive
  class Question < ApiResource
    # Associations
    belongs_to  :group
    belongs_to  :user
    has_many    :answers
  end
end
