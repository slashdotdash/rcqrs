module Bus
  class CommandBus
    attr_reader :router
    
    def initialize
      @router = CommandRouter.instance
    end    

    # Dispatch command to registered handlers
    def dispatch(command)
      @router.handlers_for(command).each do |handler|
        handler.execute(command)
      end
    end
  end
end