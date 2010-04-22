module Commands
  class CreateCompanyCommand < BaseCommand
    attr_reader :name
    validates_presence_of :name
    
    initializer :name
  end
end