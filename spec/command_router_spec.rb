require File.join(File.dirname(__FILE__), '/../lib/cqrs')

module Bus  
  describe CommandRouter do
    context "when getting handler for commands" do
      before(:each) do
        @router = CommandRouter.new
      end

      it "should raise a MissingHandler exception when no command handler is found" do
        proc { @router.handler_for(nil) }.should raise_error(Commands::MissingHandler)
      end
      
      it "should find the corresponding handler for a command" do
        command = Commands::CreateCompanyCommand.new
        handler = @router.handler_for(command)
        handler.should be_instance_of(Commands::Handlers::CreateCompanyHandler)
      end
    end
  end
end