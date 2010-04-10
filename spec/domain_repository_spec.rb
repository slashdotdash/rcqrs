require File.join(File.dirname(__FILE__), 'spec_helper')

module EventStore
  class MockStorage
    attr_reader :saved_events
    
    def initialize
      @saved_events = []
    end
    
    def save(events)
      @saved_events += events
    end
    
    def find(guid)
      @saved_events.select {|event| event.aggregate_id == guid }
    end
  end
  
  describe DomainRepository do
    before(:each) do
      @storage = MockStorage.new
      @repository = DomainRepository.new(@storage)
      @aggregate = Domain::Company.create('ACME Corp.')
    end
      
    context "when saving an aggregate" do
      before(:each) do
        @repository.save(@aggregate)
      end

      it "should persist the aggregate's applied events" do
        @storage.saved_events.should == @aggregate.applied_events
      end
      
      it "should set the aggregate id for each event" do
        @storage.saved_events.each do |event|
          event.aggregate_id.should == @aggregate.guid
        end
      end

      it "should set the aggregate id for each event" do
        @storage.saved_events.each do |event| 
          event.aggregate_class.should == 'Domain::Company'
        end
      end
    end
    
    context "when finding an aggregate that does not exist" do
      it "should raise an EventStore::AggregateNotFound exception" do
        proc { @repository.find(@aggregate.guid) }.should raise_error(EventStore::AggregateNotFound)
      end
    end
    
    context "when loading an aggregate" do
      before(:each) do
        @storage.save(@aggregate.applied_events)
        @retrieved = @repository.find(@aggregate.guid)
      end
      
      specify { @retrieved.should be_instance_of(Domain::Company) }
      specify { @retrieved.version.should == 1 }
      specify { @retrieved.applied_events.length.should == 1 }
    end
  end
end