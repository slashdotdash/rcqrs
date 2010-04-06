module Bus
  class CommandBus
    def initialize(router=CommandRouter.new)
      @router = router
    end

    # Dispatch command to registered handlers
    def dispatch(command)
      raise Commands::InvalidCommand unless command.valid?
      
      handler = @router.handler_for(command)
      handler.execute(command)
    end
  end
end