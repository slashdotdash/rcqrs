module Bus
  class CommandBus
    attr_reader :router
    
    def initialize
      @router = CommandRouter.instance
    end    

    # Dispatch command to registered handlers
    def dispatch(command)
      raise Commands::InvalidCommand unless command.valid?
      
      router.handlers_for(command).each do |handler|
        handler.new.execute(command)
      end
    end
  end
end