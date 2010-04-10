require File.join(File.dirname(__FILE__), 'spec_helper')

module Bus  
  describe CommandBus do
    context "when dispatching commands" do
      before(:each) do
        @router = MockRouter.new
        @repository = mock
        @bus = CommandBus.new(@router, @repository)
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