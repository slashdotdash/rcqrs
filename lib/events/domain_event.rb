module Events
  class DomainEvent
    include Rcqrs::Serialization
    
    attr_accessor :aggregate_id, :version
  end
end