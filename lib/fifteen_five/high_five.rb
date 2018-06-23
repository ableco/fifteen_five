module FifteenFive
  class HighFive < ApiResource
    # Associations
    belongs_to  :creator, class_name: "User"
    belongs_to  :report

    # Her association request paths.
    collection_path "high-five/"
    resource_path "high-five/:id/"
  end
end
