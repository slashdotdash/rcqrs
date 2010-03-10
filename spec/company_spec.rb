require File.join(File.dirname(__FILE__), '/../lib/cqrs')

module Domain
  describe Company do
    context "when creating" do
      before(:each) do
        @event_raised = false
        Company.on(Events::CompanyCreatedEvent) {|source, event| @event_raised = true }
        
        @company = Company.create('ACME Corp')
      end
    
      it "should set the company name" do
        @company.name.should == 'ACME Corp'
      end
      
      it "should raise the company_created event" do
        @event_raised.should == true
      end
      
      it "should have a Events::CompanyCreatedEvent event" do
        @company.applied_events.length.should == 1
        @company.applied_events.last.should be_an_instance_of(Events::CompanyCreatedEvent)
      end
      
      context "when adding an invoice" do
        before(:each) do
          @company.create_invoice("invoice-1", Time.now, "First invoice", 100)
        end
        
        it "should create a new invoice" do
          @company.invoices.length.should == 1
        end
      end
    end
  end
end