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
      Eventful.on(:domain_event) {|source, event| events << event unless source == self }
      yield
      events.each {|event| fire(:domain_event, event) }
    end
  end
end