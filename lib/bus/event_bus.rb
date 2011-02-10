module Bus
  class EventBus
    def initialize(router)
      @router = router
    end

    # Publish event to registered handlers
    def publish(event)
      handler = @router.handler_for(event, nil)
      handler.execute(event)
    end
  end
end