module Commands
  module Handlers
    class BaseHandler
      def initialize(repository)
        @repository = repository
      end
    end
  end
end