require File.join(File.dirname(__FILE__), '../spec_helper')

module Bus  
  describe CommandBus do
    context "when dispatching commands" do
      before(:each) do
        @router = MockRouter.new
        @bus = CommandBus.new(@router, nil)
      end
      
      context "invalid command" do
        subject { Commands::CreateCompanyCommand.new }
        
        it "should raise an InvalidCommand exception when the command is invalid" do
          proc { @bus.dispatch(subject) }.should raise_error(Commands::InvalidCommand)
          subject.errors[:name].should == ["can't be blank"]
        end
      end
      
      context "valid command" do
        subject { Commands::CreateCompanyCommand.new('foo') }
        
        it "should execute handler for given command" do
          @bus.dispatch(subject)
          @router.handled.should == true
        end
      end
    end
  end
end