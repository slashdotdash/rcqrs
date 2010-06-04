module Domain
  class Invoice
    extend Rcqrs::Initializer
    initializer :number, :date, :description, :gross, :vat, :attr_reader => true
  end
end