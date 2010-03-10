module Domain
  class Invoice
    attr_reader :date, :description, :number, :gross, :vat
    
    def initialize(number, date, description, gross, vat)
      @number = number
      @date = date
      @description = description
      @gross = gross
      @vat = vat
    end
  end
end