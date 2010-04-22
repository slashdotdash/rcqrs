module Domain
  class Expense
    extend Rcqrs::Initializer
    
    attr_reader :date, :description, :gross, :vat
    
    initializer :date, :description, :gross, :vat
  end
end