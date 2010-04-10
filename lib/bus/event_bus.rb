module Bus
  class EventBus
    def initialize(router, repository)
      @router, @repository = router, repository
      wire_events
    end

  private
    
    # Subscribe to all events raised by any aggregate root
    def wire_events
      event_types.each do |event_type|
        Domain::BaseAggregateRoot.on(event_type) {|source, event| dispatch(event) }
      end
    end
    
    # Get all of the known event class types
    def event_types
      Events.constants.map {|event| Events.const_get(event) }
    end
    
    # Dispatch event to registered handler
    def dispatch(event)
      handler = @router.handler_for(event, @repository)
      handler.execute(event)
    end
  end
end