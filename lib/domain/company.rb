module Domain
  class Company < BaseAggregateRoot
    attr_reader :name
    attr_reader :invoices

    VAT_RATE = 0.175  # TODO: lookup
    
    def initialize(guid, name)
      super()
      register_events

      apply(Events::CompanyCreatedEvent.new(guid, name))
    end

    def self.create(name)
      Company.new(UUID.new, name)
    end
  
    def create_invoice(number, date, description, amount)
      vat = amount * VAT_RATE
      apply(Events::InvoiceCreatedEvent.new(number, date, description, amount, vat))
    end

  private
  
    def on_company_created(event)
      @guid, @name = event.guid, event.name
      @invoices = []
    end
    
    def on_invoice_created(event)
      @invoices << Invoice.new(event.number, event.date, event.description, event.gross, event.vat)
    end
    
    def register_events
      on(Events::CompanyCreatedEvent) {|source, event| source.send(:on_company_created, event) }
      on(Events::InvoiceCreatedEvent) {|source, event| source.send(:on_invoice_created, event) }
    end
  end
end