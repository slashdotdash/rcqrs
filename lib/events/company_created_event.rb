module Events
  class CompanyCreatedEvent < DomainEvent
    attr_reader :guid, :name
    
    initializer :guid, :name
  end
end