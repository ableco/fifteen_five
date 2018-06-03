module FifteenFive
  class SecurityAudit < ApiResource
    # Associations
    belongs_to :actor, class_name: "User"
    collection_path "security-audit/"
  end
end
