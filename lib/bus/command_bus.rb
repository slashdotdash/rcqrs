module Bus
  class CommandBus
    def initialize(router, repository)
      @router, @repository = router, repository
    end

    # Dispatch command to registered handler
    def dispatch(command)
      raise Commands::InvalidCommand unless command.valid?
      
      handler = @router.handler_for(command, @repository)
      handler.execute(command)
    end
  end
end