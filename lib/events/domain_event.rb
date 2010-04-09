module Events
  class DomainEvent
    extend Rcqrs::Initializer
    include Rcqrs::Serialization
    
    attr_accessor :aggregate_id, :aggregate_class, :version
  end
end