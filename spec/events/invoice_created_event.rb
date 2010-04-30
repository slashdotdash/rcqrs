module Events
  class InvoiceCreatedEvent < DomainEvent
    attr_reader :date, :number, :description, :gross, :vat
    initializer :date, :number, :description, :gross, :vat
  end
end