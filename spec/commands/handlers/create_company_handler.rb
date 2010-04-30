module Commands
  module Handlers
    class CreateCompanyHandler < BaseHandler
      def execute(command)
        company = Domain::Company.create(command.name)
        @repository.save(company)
      end
    end
  end
end