module Reporting
  class Company
    extend Rcqrs::Initializer        
    
    attr_reader :guid, :name
    
    initializer :guid, :name
  end
end