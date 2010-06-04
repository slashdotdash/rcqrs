module Bus
  class MissingHandler < StandardError; end
  
  class Router
    def handler_for(target, repository=nil)
      handler_class = (handlers[target.class] ||= handler_class_for(target))
      handler_class.new(repository)
    end
    
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
  
  class EventRouter < Router
  end
  
  class CommandRouter < Router
  end
end