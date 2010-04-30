module Domain
  module AggregateRoot
    def self.extended(base)
      base.class_eval do
        include Eventful
        include InstanceMethods
      end
    end
    
    def create_from_event(event)
      returning self.new do |aggregate|
        aggregate.send(:apply, event)
      end
    end
    
    # Register events that this class wants to be notified of
    def register_events(*events)
      events.each do |event_type|
        target = event_type.to_s.demodulize.underscore.sub(/_event$/, '')
        target = "on_#{target}".to_sym

        on(event_type) do |source, event|
          # Handle event internally
          source.send(target, event)
      
          # Notify subscribers
          source.send(:fire, :domain_event, event) unless source.replaying?
        end
      end
    end

    module InstanceMethods
      attr_reader :guid, :applied_events, :version, :source_version
      
      # Replay the given events, ordered by version
      def load(events)
        @replaying = true

        events.sort_by {|e| e.version }.each do |event|
          replay(event)
        end
      ensure
        @replaying = false
      end

      # Events applied since the source version (unsaved events)
      def pending_events
        @applied_events.select {|e| e.version > @source_version }.sort_by {|e| e.version }
      end
  
      def replaying?
        @replaying
      end
  
      def sync_versions
        @source_version = @version
      end
  
    protected

      def initialize
        @version = 0
        @source_version = 0
        @applied_events = []
      end
      
      def apply(event)
        apply_event(event)
        update_event(event)
      end
      
    private

      # Replay an existing event loaded from storage
      def replay(event)
        apply_event(event)
        @source_version += 1
      end

      def apply_event(event)
        fire(event.class, event)
    
        @applied_events << event      
        @version += 1
      end

      def update_event(event)
        event.aggregate_id = @guid
        event.version = @version
      end
    end
  end
end