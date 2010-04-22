module Rcqrs
  class Guid
    def self.create
      UUIDTools::UUID.timestamp_create.to_s
    end
  end
end