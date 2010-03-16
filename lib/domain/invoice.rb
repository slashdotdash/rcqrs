module Domain
  class Invoice
    extend Rcqrs::Initializer
    
    attr_reader :number, :date, :description, :gross, :vat
    
    initializer :number, :date, :description, :gross, :vat
  end
end