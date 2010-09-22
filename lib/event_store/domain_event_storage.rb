module EventStore
  class DomainEventStorage
    def find(guid)
      raise 'method to be implemented in adapter'
    end
    
    def save(aggregate)
      raise 'method to be implemented in adapter'
    end 
    
    # Default does not support transactions
    def transaction(&block)
      yield
    end
  end
end