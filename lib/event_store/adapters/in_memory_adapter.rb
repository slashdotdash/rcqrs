require 'active_record'

module EventStore
  module Adapters
    module InMemory
      class EventProvider
        attr_reader :aggregate_id, :aggregate_type, :version, :events
      
        def initialize(aggregate)
          @aggregate_id = aggregate.guid
          @aggregate_type = aggregate.class.name
          @version = aggregate.version
          @events = aggregate.pending_events.map {|e| Event.new(e) }
        end
      end
    
      class Event
        attr_reader :aggregate_id, :event_type, :version, :data
      
        def initialize(event)
          @aggregate_id = event.aggregate_id
          @event_type = event.class.name
          @version = event.version
          @data = event.attributes_to_json
        end
      end
    end
    
    class InMemoryAdapter < EventStore::DomainEventStorage
      attr_reader :storage
      
      def initialize(options={})
        @storage = {}
      end
      
      def find(guid)
        @storage[guid]
      end

      def save(aggregate)
        @storage[aggregate.guid] = InMemory::EventProvider.new(aggregate)
      end
    end
  end
end