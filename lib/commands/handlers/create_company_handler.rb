module Commands
  module Handlers
    class CreateCompanyHandler < BaseCommandHandler
      def execute(command)
        returning Domain::Company.create(command.name) do |company|
          @repository.save(company)
        end
      end
    end
  end
end