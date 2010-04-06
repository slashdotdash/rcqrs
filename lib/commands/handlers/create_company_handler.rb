module Commands
  module Handlers
    class CreateCompanyHandler
      def execute(command)
        Domain::Company.create(command.name)
      end
    end
  end
end