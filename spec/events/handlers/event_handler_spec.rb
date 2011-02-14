require File.join(File.dirname(__FILE__), '../../spec_helper')

module Events
  module Handlers
    describe CompanyCreatedHandler do
      before(:each) do
        @handler = CompanyCreatedHandler.new
      end
      
      context "when executing" do
        before(:each) do
          @event = Events::CompanyCreatedEvent.new(:guid => Rcqrs::Guid.create, :name => 'ACME corp')
          @company = @handler.execute(@event)
        end
        
        specify { @company.should be_instance_of(Reporting::Company) }
        specify { @company.guid.should == @event.guid }
        specify { @company.name.should == @event.name }
      end
    end
  end
end