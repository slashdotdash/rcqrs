module Bus
  class CommandBus
    include Eventful
    
    def initialize(router, repository)
      @router, @repository = router, repository
    end

    # Dispatch command to registered handler
    def dispatch(command)
      raise Commands::InvalidCommand unless command.valid?
      
      capture_and_raise_events do
        handler = @router.handler_for(command, @repository)
        handler.execute(command)
      end
    end
    
  private
  
    # Capture all raised domain events and replay after block has executed
    def capture_and_raise_events(&block)
      events = []
      observer = Eventful.on(:domain_event) {|source, event| events << event }
      begin
        yield
      ensure
        Eventful.delete_observer(observer)
      end
      replay(events)
    end
    
    def replay(events)
      events.each {|event| fire(:domain_event, event) }
    end
  end
end