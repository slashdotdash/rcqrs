require File.join(File.dirname(__FILE__), '/../lib/cqrs')

class MockRouter
  attr_reader :handled
  
  def handler_for(command)
    self
  end
  
  def execute(command)
    @handled = true
  end
end

module Bus  
  describe CommandBus do
    context "when dispatching commands" do
      before(:each) do
        @router = MockRouter.new
        @bus = CommandBus.new(@router)
      end

      it "should raise an InvalidCommand exception when the command is invalid" do
        command = Commands::CreateCompanyCommand.new
        proc { @bus.dispatch(command) }.should raise_error(Commands::InvalidCommand)
        command.errors.on(:name).should == "can't be empty"
      end

      it "should execute handler for given command" do
        @bus.dispatch(Commands::CreateCompanyCommand.new('foo'))
        @router.handled.should == true        
      end
    end
  end
end