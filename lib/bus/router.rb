module Bus
  class MissingHandler < StandardError; end
  
  class Router
  protected
    def handler_class_for(target)
      handler_name = "#{target.class.name.gsub(/Event$|Command$/, '')}Handler"
      handler_name.gsub!(/::/, '::Handlers::') if handler_name =~ /::/
      handler_name.constantize
    rescue NameError => ex  
      raise MissingHandler.new("No handler found for #{target.class.name} (expected #{handler_name})")
    end

    def handlers
      @handlers ||= {}
    end
  end

  class CommandRouter < Router
    # Commands can only have a single handler
    def handler_for(target, repository)
      handler_class = (handlers[target.class] ||= handler_class_for(target))
      handler_class.new(repository)
    end
  end
  
  class EventRouter < Router
    # Events may have one or more handlers
    def handlers_for(target)
      handler_class = (handlers[target.class] ||= handler_class_for(target))
      [ handler_class.new ] # (only currently support single handler)
    end
  end
end