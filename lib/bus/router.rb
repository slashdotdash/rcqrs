module Bus
  class MissingHandler < StandardError; end
  
  class Router
    def initialize(available_handlers)
      @available_handlers = available_handlers
      load_handlers
    end

    def handler_for(target, repository)
      handler_class = (handlers[target.class] ||= handler_class_for(target))
      handler_class.new(repository)
    end
    
  protected
  
    def handler_class_for(target)
      handler_name = "#{target.class.name.gsub(/^Events::|Event$|^Commands::|Command$/, '')}Handler"
      raise MissingHandler unless @available_handlers.const_defined?(handler_name)
      
      @available_handlers.const_get(handler_name)
    end
    
    def load_handlers
      lib_dir = File.dirname(__FILE__)
      source = self.class.name.gsub(/Router/, '').downcase
      full_pattern = File.join(lib_dir, '..', source, 'handlers', '*.rb') 
      Dir.glob(full_pattern).each {|file| require file } 
    end

    def handlers
      @handlers ||= {}
    end
  end
  
  class EventRouter < Router
    def initialize
      super(Events::Handlers)
    end
  end
  
  class CommandRouter < Router
    def initialize
      super(Commands::Handlers)
    end
  end
end