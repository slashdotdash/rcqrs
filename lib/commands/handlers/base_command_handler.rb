module Commands
  module Handlers
    class BaseHandler

      # Does this class handle the given command?
      def handler?(command)
        BaseHandler.router.handler?(command, self)
      end
      
    protected
    
      # Register the class to handle a given command
      def self.handle(command)
        router.register(command, self)
      end
      
      def self.router
        Bus::CommandRouter.instance
      end
    end
  end
end