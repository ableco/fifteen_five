module FifteenFive
  class Objective < ApiResource
    # Associations
    belongs_to  :parent, class_name: "Objective"
    belongs_to  :user
    has_many    :children, class_name: "Objective"
    has_many    :departments
  end
end
