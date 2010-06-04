module Domain
  class Expense
    extend Rcqrs::Initializer
    initializer :date, :description, :gross, :vat, :attr_reader => true
  end
end