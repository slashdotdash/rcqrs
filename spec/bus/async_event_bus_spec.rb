require File.join(File.dirname(__FILE__), '../spec_helper')
require 'resque'

module Bus  
  describe AsyncEventBus do
    context "when publishing events" do
      subject { AsyncEventBus.new(MockRouter.new(MockAsyncHandler.new)) }

      it "should enqueue Resque with handler class and event" do
        event = Events::CompanyCreatedEvent.new
        ::Resque::Job.should_receive(:create).with('rcqrs', MockAsyncHandler, event.class.to_s, event.to_json)
        
        subject.publish(event)
      end
    end
  end
end