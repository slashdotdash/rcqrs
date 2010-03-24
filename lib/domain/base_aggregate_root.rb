module Domain
  class BaseAggregateRoot
    include Eventful

    attr_reader :guid, :event_version, :applied_events
    
    # Replay the given events, ordered by version
    def load(events)
      return if events.length == 0

      events.sort_by {|e| e.version }.each do |event|
        apply(event)
      end

      @version = events.last.version
    end

  protected

    def initialize
      @version = 0
      @applied_events = []
    end

    def apply(event)
      event.aggregate_id = @guid
      event.version = ++@version

      fire(event.class, event)
      
      @applied_events << event
    end
    
    # Register events that this class wants to be notified of.
    # Convention over configuration is used:-
    #   Events::CompanyCreatedEvent maps to method on_company_created
    def self.register_events(*events)
      events.each do |event_type|
        target = event_type.to_s.demodulize.underscore.sub(/_event$/, '')
        target = "on_#{target}".to_sym

        on(event_type) {|source, event| source.send(target, event)}
      end
      
      # on(Events::CompanyCreatedEvent) {|source, event| source.send(:on_company_created, event) }
      # on(Events::InvoiceCreatedEvent) {|source, event| source.send(:on_invoice_created, event) }
    end
  end
end