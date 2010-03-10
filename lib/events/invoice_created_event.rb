module Events
  class InvoiceCreatedEvent < DomainEvent
    attr_reader :number, :date, :description, :gross, :vat
    
    def initialize(number, date, description, gross, vat)
      @number = number
      @date = date
      @description = description
      @gross = gross
      @vat = vat
    end
  end
end