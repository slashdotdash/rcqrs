module Commands
  class CreateCompanyCommand
    extend ActiveModel
    
    attr_reader :name
    validates_presence_of :name
    
    initializer :name
  end
end