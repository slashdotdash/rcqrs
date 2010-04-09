module Domain
  class BaseAggregateRoot
    include Eventful

    attr_reader :guid, :applied_events, :version
    
    # Replay the given events, ordered by version
    def load(events)
      return if events.length == 0

      events.sort_by {|e| e.version }.each do |event|
        apply(event, true)
      end
    end

  protected

    def initialize
      @version = 0
      @applied_events = []
    end

    def apply(event, loading=false)
      fire(event.class, event)
      
      @version += 1      
      update_event(event) unless loading
      
      @applied_events << event
    end
    
    def update_event(event)
      event.aggregate_id = @guid
      event.aggregate_class = self.class.name
      event.version = @version
    end
    
    # Register events that this class wants to be notified of
    # 
    # Event types are mapped to their corresponding method by name so 
    # +Events::CompanyCreatedEvent+ invokes method +on_company_created+
    def self.register_events(*events)
      events.each do |event_type|
        target = event_type.to_s.demodulize.underscore.sub(/_event$/, '')
        target = "on_#{target}".to_sym

        on(event_type) {|source, event| source.send(target, event) }
      end
    end
  end
end