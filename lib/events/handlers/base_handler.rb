module Events
  module Handlers
    class BaseHandler
      def execute(event)
        raise NotImplementedError, 'method to be implemented in handler'
      end
    end
  end
end