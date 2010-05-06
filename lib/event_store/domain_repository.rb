module EventStore
  class AggregateNotFound < StandardError; end
  class AggregateConcurrencyError < StandardError; end
  class UnknownAggregateClass < StandardError; end
    
  class DomainRepository
    def initialize(event_store)
      @event_store = event_store
      @tracked_aggregates = {}
    end
    
    # Persist the +aggregate+ to the event store
    def save(aggregate)
      track(aggregate)

      @event_store.transaction do
        @tracked_aggregates.each do |guid, tracked|
          next unless tracked.pending_events?

          @event_store.save(tracked)
          tracked.sync_versions
        end
      end
    end

    # Find an aggregate by the given +guid+
    # Track any changes to the returned aggregate, commiting those changes when saving aggregates
    # 
    # == Exceptions
    #
    # * AggregateNotFound - No aggregate for the given +guid+ was found
    # * UnknownAggregateClass - The type of aggregate is unknown
    def find(guid)
      return @tracked_aggregates[guid] if @tracked_aggregates.has_key?(guid)

      provider = @event_store.find(guid)
      raise AggregateNotFound if provider.nil?

      load_aggregate(provider.aggregate_type, provider.events)
    end
    
  private
  
    # Track changes to this aggregate root so that any unsaved events
    # are persisted when save is called (for any aggregate)
    def track(aggregate)
      @tracked_aggregates[aggregate.guid] = aggregate
    end
    
    # Recreate an aggregate root by re-applying all saved +events+
    def load_aggregate(klass, events)
      returning create_aggregate(klass) do |aggregate|
        events.map! {|event| create_event(event) }
        aggregate.load(events)
        track(aggregate)
      end
    end
    
    # Create a new instance an aggregate from the given +events+
    def create_aggregate(klass)
      klass.constantize.new
    end
    
    # Create a new instance of the domain event from the serialized json
    def create_event(event)
      returning event.event_type.constantize.from_json(event.data) do |domain_event|
        domain_event.version = event.version.to_i
        domain_event.aggregate_id = event.aggregate_id.to_s
      end
    end
  end
end