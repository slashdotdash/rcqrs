module Events
  class InvoiceCreatedEvent < DomainEvent
    attr_reader :number, :date, :description, :gross, :vat

    initializer :number, :date, :description, :gross, :vat    
  end
end