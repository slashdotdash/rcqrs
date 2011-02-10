module Events
  module Handlers
    class BaseHandler
      def initialize(repository)
        @repository = repository
      end
    end
    
    def execute(event)
      raise 'method to be implemented in handler'
    end
  end
end