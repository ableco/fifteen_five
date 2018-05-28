module FifteenFive
  class ResponseParser < Her::Middleware::FirstLevelParseJSON
    def parse(body)
      json      = parse_json(body)
      errors    = json.delete(:error)     || {}
      metadata  = json.delete(:metadata)  || {}
      data      = json.delete(:results)   || json

      {
        data:     data,
        errors:   errors,
        metadata: metadata
      }
    end
  end
end
