module Bus
  class EventRouter
    def initialize
      load_handlers
    end

    def handler_for(event, repository)
      handler_class = (handlers[command.class] ||= handler_class_for(command))
      handler_class.new(repository)
    end
    
  private
  
    def handler_class_for(event)
      handler_name = "#{event.class.name.gsub(/^Events::|Event$/, '')}Handler"
      raise Commands::MissingHandler unless Events::Handlers.const_defined?(handler_name)
      
      Events::Handlers.const_get(handler_name)
    end
      
    def load_handlers
      lib_dir = File.dirname(__FILE__) 
      full_pattern = File.join(lib_dir, '..', 'events', 'handlers', '*.rb') 
      Dir.glob(full_pattern).each {|file| require file } 
    end

    def handlers
      @handlers ||= {}
    end
  end
end