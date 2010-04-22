module Events
  module Handlers
    class CompanyCreatedHandler < BaseHandler
      def execute(event)
        company = ::Reporting::Company.new(event.guid, event.name)
        @repository.save(company)
        # Company.create!(:guid => event.guid, :name => event.name)
      end
    end
  end
end