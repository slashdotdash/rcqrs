require File.join(File.dirname(__FILE__), 'spec_helper')

module Bus  
  describe EventBus do
    context "when dispatching events" do
      before(:each) do
        @router = MockRouter.new
        @repository = mock
        @bus = EventBus.new(@router, @repository)
      end

      it "should execute handler for raised event" do
        Domain::Company.create('ACME Corp')
        @router.handled.should == true
      end
    end
  end
end