require File.join(File.dirname(__FILE__), '/../../lib/cqrs')

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
          @adapter.save(@aggregate.applied_events)
          @events = @adapter.find(@aggregate.guid)
        end

        it "should persist a single event" do
          count = @adapter.connection.select_value('select count(*) from events').to_i
          count.should == 1
        end

        specify { @events.count.should == 1 }
        specify { @events.first.aggregate_id.should == @aggregate.guid }
        specify { @events.first.aggregate_class.should == 'Domain::Company' }
        specify { @events.first.version.should == 1 }
      end
    end
  end
end