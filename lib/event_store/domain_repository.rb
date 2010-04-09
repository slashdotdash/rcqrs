module EventStore
  class AggregateNotFound < StandardError; end
  class UnknownAggregateClass < StandardError; end
    
  class DomainRepository
    def initialize(event_store)
      @event_store = event_store
    end
    
    # Persist the +aggregate+ to the event store
    def save(aggregate)
      @event_store.save(aggregate.applied_events)
    end
    
    # Find an aggregate by the given +guid+
    #
    # == Exceptions
    #
    # * AggregateNotFound - No events were found for the given +guid+
    # * UnknownAggregateClass - The type of aggregate is unknown
    def find(guid)
      events = @event_store.find(guid)
      raise AggregateNotFound if events.empty?

      load_aggregate(events)
    end
    
  private
  
    # Recreate an aggregate root by re-applying all saved +events+
    def load_aggregate(events)
      returning create_aggregate(events) do |aggregate|
        aggregate.load(events)
      end
    end
    
    # Create a new instance an aggregate from the given +events+
    def create_aggregate(events)
      aggregate_class = events.first.aggregate_class.gsub(/^Domain::/, '')
      raise UnknownAggregateClass unless Domain.const_defined?(aggregate_class)
      
      Domain.const_get(aggregate_class).new
    end
  end
end