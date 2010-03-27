module Bus
  class CommandRouter
    include Singleton
    
    # Register a handler for a given command    
    def register(command, handler)
      (handlers[k(command)] ||= []) << k(handler)
    end
    
    def handler?(command, handler)
      handlers.has_key?(k(command)) && handlers[k(command)].include?(k(handler))
    end
    
    # Get the registered handlers for the given command
    def handlers_for(command)
      raise Exception('No registered handler') unless handlers.has_key?(k(command))
      
      handlers[k(command)]
    end
    
  private
    
    def k(obj_or_klass)
      obj_or_klass.is_a?(Class) ? obj_or_klass : obj_or_klass.class
    end
    
    def handlers
      @handlers ||= {}
    end
  end
end