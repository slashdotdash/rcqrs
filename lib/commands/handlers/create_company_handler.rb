module Commands
  module Handlers
    class CreateCompanyHandler < BaseHandler
      handle Commands::CreateCompanyCommand
      
      def execute(event)
        Domain::Company.create(event.name)
      end
    end
  end
end