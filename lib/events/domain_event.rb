module Events
  class DomainEvent
    extend Rcqrs::Initializer
    include Rcqrs::Serialization
    
    attr_accessor :aggregate_id, :version, :timestamp
  end
end