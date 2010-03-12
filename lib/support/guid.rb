module Rcqrs
  class Guid
    def self.create
      UUIDTools::UUID.random_create.to_s
    end
  end
end