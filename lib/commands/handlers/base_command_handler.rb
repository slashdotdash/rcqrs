module Commands
  module Handlers
    class BaseCommandHandler
      def initialize(repository)
        @repository = repository
      end
    end
  end
end