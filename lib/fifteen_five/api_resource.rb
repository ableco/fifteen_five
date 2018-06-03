module FifteenFive
  class ApiResource
    include Her::Model

    def self.inherited(klass)
      resource_name = klass.name.demodulize.downcase
      klass.collection_path("#{resource_name}/")
      klass.resource_path("#{resource_name}/:id/")
    end
  end
end
