module Bus
  class EventBus
    def initialize(router, repository)
      @router, @repository = router, repository
      wire_events
    end

  private
    
    # Subscribe to all events triggered by command handlers
    def wire_events
      Bus::CommandBus.on(:domain_event) {|source, event| dispatch(event) }
    end
    
    # Dispatch event to registered handler
    def dispatch(event)
      handler = @router.handler_for(event, @repository)
      handler.execute(event)
    end
  end
end