module Events
  class CompanyCreatedEvent < DomainEvent
    attr_reader :guid, :name
    
    def initialize(guid, name)
      @guid, @name = guid, name
    end
  end
end