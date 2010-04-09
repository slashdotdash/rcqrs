module Bus
  class EventBus
    def initialize(router, repository)
      @router, @repository = router, repository
      
      wire_events
    end

  private
    
    def wire_events
      Events.constants.each do |event| 
        Events.const_get(event)
        # Domain.
      end
    end
    
    # Dispatch event to registered handler
    def dispatch(event)
      handler = @router.handler_for(event, @repository)
      handler.execute(event)
    end
  end
end