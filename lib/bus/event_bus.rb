module Bus
  class EventBus
    def initialize(router)
      @router = router
    end

    # Dispatch event to registered handler
    def dispatch(event)
      handler = @router.handler_for(event, nil)
      handler.execute(event)
    end
  end
end