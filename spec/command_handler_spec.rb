require File.join(File.dirname(__FILE__), 'spec_helper')

module Commands
  module Handlers
    describe CreateCompanyHandler do
      before(:each) do
        @repository = mock
        @handler = CreateCompanyHandler.new(@repository)
      end
      
      context "when executing command" do
        before(:each) do
          @repository.should_receive(:save) {|company| @company = company }
          @command = Commands::CreateCompanyCommand.new(:name => 'ACME corp')
          @handler.execute(@command)
        end
        
        specify { @company.should be_instance_of(Domain::Company) }
        specify { @company.name.should == @command.name }
      end
    end
  end
end