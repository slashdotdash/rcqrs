require File.join(File.dirname(__FILE__), '../spec_helper')

module EventStore
  module Adapters
    describe ActiveRecordAdapter do
      before(:each) do
        # Use an in-memory sqlite db
        @adapter = ActiveRecordAdapter.new(:adapter => 'sqlite3', :database => ':memory:')
        @aggregate = Domain::Company.create('ACME Corp')
      end

      context "when saving events" do
        before(:each) do
          @adapter.save(@aggregate)
          @provider = @adapter.find(@aggregate.guid)
        end

        it "should persist a single event provider (aggregate)" do
          count = @adapter.provider_connection.select_value('select count(*) from event_providers').to_i
          count.should == 1
        end

        it "should persist a single event" do
          count = @adapter.event_connection.select_value('select count(*) from events').to_i
          count.should == 1
        end

        specify { @provider.aggregate_type.should == 'Domain::Company' }
        specify { @provider.aggregate_id.should == @aggregate.guid }
        specify { @provider.version.should == 1 }
        specify { @provider.events.count.should == 1 }
        
        context "persisted event" do
          before(:each) do
            @event = @provider.events.first
          end
                    
          specify { @event.aggregate_id.should == @aggregate.guid }
          specify { @event.event_type.should == 'Events::CompanyCreatedEvent' }        
          specify { @event.version.should == 1 }
        end
      end
      
      context "when saving incorrect aggregate version" do
        before(:each) do
          @adapter.save(@aggregate)
        end
        
        it "should raise AggregateConcurrencyError exception" do
          proc { @adapter.save(@aggregate) }.should raise_error(AggregateConcurrencyError)
        end
      end
      
      context "when finding events" do
        it "should return nil when aggregate not found" do
          @adapter.find('').should == nil
        end
      end
      
      context "when saving aggregate within a transaction" do
        before (:each) do
          begin
            @adapter.transaction do
              @adapter.save(@aggregate)
              event_provider_count.should == 1
              event_count.should == 1
            
              raise 'rollback'
            end
          rescue
            # expected rollback exception
          end
        end
        
        def event_provider_count
          @adapter.provider_connection.select_value('select count(*) from event_providers').to_i
        end

        def event_count
          @adapter.event_connection.select_value('select count(*) from events').to_i
        end
        
        it "should rollback saved event provider" do
          event_provider_count.should == 0
        end
        
        it "should rollback saved events" do
          event_count.should == 0
        end
      end
    end
  end
end