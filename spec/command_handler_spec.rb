require File.join(File.dirname(__FILE__), '/../lib/cqrs')

module Commands
  module Handlers
    describe CreateCompanyHandler do
      before(:each) do
        @handler = CreateCompanyHandler.new
      end
      
      context "when executing command" do
        before(:each) do
          @command = Commands::CreateCompanyCommand.new(:name => 'ACME corp')
          @company = @handler.execute(@command)
        end
        
        specify { @company.should be_instance_of(Domain::Company) }
        specify { @company.name.should == @command.name }
      end
    end
  end
end