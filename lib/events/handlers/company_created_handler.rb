module Events
  module Handlers
    class CompanyCreatedHandler < BaseHandler
      def execute(event)
        company = ::Reporting::Company.new(event.guid, event.name)
        @repository.save(company)
      end
    end
  end
end