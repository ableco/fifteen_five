module FifteenFive
  class Answer < ApiResource
    # Associations
    belongs_to  :question
    belongs_to  :user
  end
end
