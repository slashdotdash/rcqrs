module Bus
  class EventBus
    def initialize(router)
      @router = router
    end

    # Publish event to registered handlers
    def publish(event)
      @router.handlers_for(event).each do |handler|
        handler.execute(event)
      end
    end
  end
end