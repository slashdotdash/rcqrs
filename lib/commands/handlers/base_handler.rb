module Commands
  module Handlers
    class BaseHandler
      def initialize(repository)
        @repository = repository
      end

      def execute(command)
        raise NotImplementedError, 'method to be implemented in handler'
      end
    end
  end
end