module Rcqrs
  class Guid
    def self.create
      UUIDTools::UUID.timestamp_create.to_s
    end
    
    def self.parse(guid)
      UUIDTools::UUID.parse(guid)
    end
    
    # Is the given string a valid guid?
    def self.valid?(guid)
      UUIDTools::UUID.parse_raw(guid).valid?
    end
  end
end