require File.join(File.dirname(__FILE__), '/../lib/cqrs')

module Commands
  module Handlers
    describe CreateCompanyHandler do
      context "ctr" do
        before(:each) do
          @handler = CreateCompanyHandler.new
          @router = Bus::CommandRouter.instance
        end
    
        it "should be a handler for CreateCompanyCommand" do
          @handler.should be_a_handler(Commands::CreateCompanyCommand)
        end
        
        it "should be registered with the command router" do
          @router.handlers_for(Commands::CreateCompanyCommand).should include(@handler.class)
        end
      end
    end
  end
end