module FifteenFive
  class Group < ApiResource
    # Associations
    has_many  :members, class_name: "User"
    has_many  :questions
  end
end
