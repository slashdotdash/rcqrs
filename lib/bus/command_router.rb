module Bus
  class CommandRouter
    def initialize
      load_handlers
    end
    
    # Register a handler for a given command    
    # def register(command_class, handler_class)
    #   (handlers[command_class] ||= []) << handler_class
    # end
    
    def handler_for(command)
      handler_class = (handlers[command.class] ||= handler_class_for(command))
      handler_class.new
    end
    
  private
  
    # Get the handler class for a given command.
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

# module Bus
#   class CommandRouter
#     include Singleton
#     
#     # Register a handler for a given command    
#     def register(command, handler)
#       (handlers[k(command)] ||= []) << k(handler)
#     end
#     
#     def handler?(command, handler)
#       handlers.has_key?(k(command)) && handlers[k(command)].include?(k(handler))
#     end
#     
#     # Get the registered handlers for the given command
#     def handlers_for(command)
#       raise Exception('No registered handler') unless handlers.has_key?(k(command))
#       
#       handlers[k(command)]
#     end
#     
#   private
#     
#     def k(obj_or_klass)
#       obj_or_klass.is_a?(Class) ? obj_or_klass : obj_or_klass.class
#     end
#     
#     def handlers
#       @handlers ||= {}
#     end
#   end
# end