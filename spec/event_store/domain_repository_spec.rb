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
        @domain_event_raised = false
        @repository.on(:domain_event) {|source, event| @domain_event_raised = true }
        @repository.save(@aggregate)
      end

      it "should persist the aggregate's applied events" do
        @storage.storage.has_key?(@aggregate.guid)
      end
      
      it "should raise domain event" do
        @domain_event_raised.should == true
      end
    end

    context "when saving an aggregate within a transaction" do
      before(:each) do
        @repository.transaction do
          @repository.within_transaction?.should == true
          @repository.save(@aggregate)
        end
      end

      it "should persist the aggregate's applied events" do
        @storage.storage.has_key?(@aggregate.guid)
      end
      
      it "should not be within a transaction afterwards" do
        @repository.within_transaction?.should == false
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
      
      subject { @retrieved }
      it { should be_instance_of(Domain::Company) }
      specify { @retrieved.version.should == 1 }
      specify { @retrieved.pending_events.length.should == 0 }
    end
    
    context "when reloading same aggregate" do
      before(:each) do
        @storage.save(@aggregate)
        @mock_storage = mock
        @repository = DomainRepository.new(@mock_storage)
        @mock_storage.should_receive(:find).with(@aggregate.guid).once.and_return { @storage.find(@aggregate.guid) }
      end
      
      it "should only retrieve aggregate once" do
        @repository.find(@aggregate.guid)
        @repository.find(@aggregate.guid)
      end
    end
  end
end