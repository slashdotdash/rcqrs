module EventStore
  class AggregateNotFound < StandardError; end
  class AggregateConcurrencyError < StandardError; end
  class UnknownAggregateClass < StandardError; end
    
  class DomainRepository
    def initialize(event_store)
      @event_store = event_store
    end
    
    # Persist the +aggregate+ to the event store
    def save(aggregate)
      @event_store.save(aggregate)
    end
    
    # Find an aggregate by the given +guid+
    #
    # == Exceptions
    #
    # * AggregateNotFound - No aggregate for the given +guid+ was found
    # * UnknownAggregateClass - The type of aggregate is unknown
    def find(guid)
      klass, events = @event_store.find(guid)
      load_aggregate(klass, events)
    end
    
  private
  
    # Recreate an aggregate root by re-applying all saved +events+
    def load_aggregate(klass, events)
      returning create_aggregate(klass) do |aggregate|
        aggregate.load(events)
      end
    end
    
    # Create a new instance an aggregate from the given +events+
    def create_aggregate(klass)
      # raise UnknownAggregateClass unless Domain.const_defined?(klass)
      klass.constantize.new
    end
  end
end