module Events
  module Handlers
    class CompanyCreatedHandler < BaseHandler
      def execute(event)
        ::Reporting::Company.new(event.guid, event.name)
        
        # ... persist to reporting data store
      end
    end
  end
end