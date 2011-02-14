require File.join(File.dirname(__FILE__), '../spec_helper')

module Bus  
  describe EventBus do
    context "when publishing events" do
      before(:each) do
        @router = MockRouter.new
        @bus = EventBus.new(@router)
        @bus.publish(Events::CompanyCreatedEvent.new)
      end

      it "should execute handler(s) for raised event" do
        @router.handled.should == true
      end
    end
  end
end