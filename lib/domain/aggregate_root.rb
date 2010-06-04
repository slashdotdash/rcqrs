module Domain
  module AggregateRoot
    def self.extended(base)
      base.class_eval do
        include InstanceMethods
      end
    end
    
    def create_from_event(event)
      returning self.new do |aggregate|
        aggregate.send(:apply, event)
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

      def replaying?
        @replaying
      end

      # Events applied since the source version (unsaved events)
      def pending_events
        @pending_events.sort_by {|e| e.version }
      end
      
      # Are there any
      def pending_events?
        @pending_events.any?
      end

      def commit
        @pending_events = []
        @source_version = @version
      end
  
    protected

      def initialize
        @version = 0
        @source_version = 0
        @applied_events = []
        @pending_events = []
        @event_handlers = {}
      end
      
      def apply(event)
        apply_event(event)
        update_event(event)
        
        @pending_events << event
      end
      
    private

      # Replay an existing event loaded from storage
      def replay(event)
        apply_event(event)
        @source_version += 1
      end

      def apply_event(event)
        invoke_event_handler(event)
        
        @version += 1
        @applied_events << event
      end

      def update_event(event)
        event.aggregate_id = @guid
        event.version = @version
      end
      
      def invoke_event_handler(event)
        target = handler_for(event.class)
        self.send(target, event)
      end
      
      # Map event type to method name: CompanyRegisteredEvent => on_company_registered(event)
      def handler_for(event_type)
        @event_handlers[event_type] ||= begin
          target = event_type.to_s.demodulize.underscore.sub(/_event$/, '')
          "on_#{target}".to_sym
        end
      end
    end
  end
end