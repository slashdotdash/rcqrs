require File.join(File.dirname(__FILE__), '../spec_helper')

module Events
  describe CompanyCreatedEvent do
    context "serialization" do
      before(:each) do
        @event = CompanyCreatedEvent.new(Rcqrs::Guid.create, 'ACME Corp')
        @event.aggregate_id = Rcqrs::Guid.create
        @json = @event.to_json
      end
    
      it "should serialize to JSON" do
        @json.length.should be > 0
      end
      
      it "should deserialize from json" do
        parsed = CompanyCreatedEvent.from_json(@json)
        
        parsed.name.should == @event.name
        parsed.guid.should == @event.guid
        parsed.aggregate_id.should == @event.aggregate_id
      end
    end
  end
end