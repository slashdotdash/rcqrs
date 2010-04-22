require File.join(File.dirname(__FILE__), '../spec_helper')

module Bus  
  describe CommandRouter do
    context "when getting handler for commands" do
      before(:each) do
        @router = CommandRouter.new
        @repository = mock
      end

      it "should raise a Bus::MissingHandler exception when no command handler is found" do
        proc { @router.handler_for(nil, @repository) }.should raise_error(Bus::MissingHandler)
      end
      
      it "should find the corresponding handler for a command" do
        command = Commands::CreateCompanyCommand.new
        handler = @router.handler_for(command, @repository)
        handler.should be_instance_of(Commands::Handlers::CreateCompanyHandler)
      end
    end
  end
end