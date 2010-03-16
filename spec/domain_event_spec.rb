require File.join(File.dirname(__FILE__), '/../lib/cqrs')

module Events
  describe CompanyCreatedEvent do
    # context "serialization" do
    #   before(:each) do
    #     @event = CompanyCreatedEvent.new(Rcqrs::Guid.create, 'ACME Corp')
    #   end
    # 
    #   it "should serialize to json" do
    #     json = @event.to_json
    #     json.length.should be > 0
    #   end
    #   
    #   it "should deserialize from json" do
    #     deserialized = CompanyCreatedEvent.new.from_json(@event.to_json)
    #     
    #     deserialized.name.should == @event.name
    #     deserialized.guid.should == @event.guid
    #   end
    # end
  end
end