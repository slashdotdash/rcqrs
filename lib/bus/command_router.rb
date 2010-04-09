module Bus
  class CommandRouter
    def initialize
      load_handlers
    end
    
    # Register a handler for a given command    
    # def register(command_class, handler_class)
    #   (handlers[command_class] ||= []) << handler_class
    # end
    
    def handler_for(command, repository)
      handler_class = (handlers[command.class] ||= handler_class_for(command))
      handler_class.new(repository)
    end
    
  private
  
    # Get the handler class for a given command
    # 
    # By convention look for a class named <command name>Handler
    #   CreateCompanyCommand => CreateCompanyHandler
    def handler_class_for(command)
      handler_name = "#{command.class.name.gsub(/^Commands::|Command$/, '')}Handler"
      raise Commands::MissingHandler unless Commands::Handlers.const_defined?(handler_name)
      
      Commands::Handlers.const_get(handler_name)
    end
      
    def load_handlers
      lib_dir = File.dirname(__FILE__) 
      full_pattern = File.join(lib_dir, '..', 'commands', 'handlers', '*.rb') 
      Dir.glob(full_pattern).each {|file| require file } 
    end

    def handlers
      @handlers ||= {}
    end
  end
end