module Events
  class DomainEvent
    attr_accessor :aggregate_id, :version
  end
end