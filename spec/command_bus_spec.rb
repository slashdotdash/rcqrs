require File.join(File.dirname(__FILE__), '/../lib/cqrs')

module Commands
  module Handlers
    class MockHandler < BaseHandler
      handle Commands::CreateCompanyCommand
      cattr_reader :handled
  
      def execute(event)
        @@handled = true
      end
    end
  end
end

module Bus  
  describe CommandBus do
    context "when dispatching commands" do
      before(:each) do
        @bus = CommandBus.new
      end
  
      it "should raise an InvalidCommand exception when the command is invalid" do
        command = Commands::CreateCompanyCommand.new
        proc { @bus.dispatch(command) }.should raise_error(Commands::InvalidCommand)
        command.errors.on(:name).should == "can't be empty"
      end
      
      it "should execute handler for given command" do
        @bus.dispatch(Commands::CreateCompanyCommand.new('foo'))
        Commands::Handlers::MockHandler.handled.should == true        
      end
    end
  end
end