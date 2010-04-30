require File.join(File.dirname(__FILE__), '../spec_helper')

module EventStore
  describe DomainRepository do
    before(:each) do
      @storage = Adapters::InMemoryAdapter.new
      @repository = DomainRepository.new(@storage)
      @aggregate = Domain::Company.create('ACME Corp.')
    end
      
    context "when saving an aggregate" do
      before(:each) do
        @repository.save(@aggregate)
      end

      it "should persist the aggregate's applied events" do
        @storage.storage.has_key?(@aggregate.guid)
      end
    end
    
    context "when finding an aggregate that does not exist" do
      it "should raise an EventStore::AggregateNotFound exception" do
        proc { @repository.find('missing') }.should raise_error(EventStore::AggregateNotFound)
      end
    end
    
    context "when loading an aggregate" do
      before(:each) do
        @storage.save(@aggregate)
        @retrieved = @repository.find(@aggregate.guid)
      end
      
      specify { @retrieved.should be_instance_of(Domain::Company) }
      specify { @retrieved.version.should == 1 }
      specify { @retrieved.applied_events.length.should == 1 }
    end
  end
end