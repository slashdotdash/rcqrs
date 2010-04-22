require File.join(File.dirname(__FILE__), '../spec_helper')

module Bus  
  describe CommandBus do
    context "when dispatching commands" do
      before(:each) do
        @router = MockRouter.new
        @bus = CommandBus.new(@router, nil)
      end

      it "should raise an InvalidCommand exception when the command is invalid" do
        command = Commands::CreateCompanyCommand.new
        proc { @bus.dispatch(command) }.should raise_error(Commands::InvalidCommand)
        command.errors[:name].should == ["can't be blank"]
      end

      it "should execute handler for given command" do
        @bus.dispatch(Commands::CreateCompanyCommand.new('foo'))
        @router.handled.should == true
      end
      
      it "should fire domain events after executing handler" do
        @bus.on(:domain_event) {|source, event| @router.handled.should == true }
        @bus.dispatch(Commands::CreateCompanyCommand.new('foo'))
      end      
    end    
  end
end