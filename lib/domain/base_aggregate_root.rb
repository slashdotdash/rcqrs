module Domain
  class BaseAggregateRoot
    include Eventful
        
    attr_reader :guid, :event_version, :applied_events
    
    # Replay the given events, ordered by version
    def load(events)
      return if events.count == 0

      events.sort_by {|e| e.version }.each do |event|
        apply(event)
      end

      @version = events.last.version
    end

  protected

    def initialize
      @version = 0
      @applied_events = []
    end

    def apply(event)
      event.aggregate_id = @guid
      event.version = ++@version

      fire(event.class, event)
      
      @applied_events << event
    end    
  end
end

# def initialize
#     # define a hash and then
#     hash.each do |k,v|
#       # attr_accessor k # optional
#       instance_variable_set(:"@#{k}", v)
#     end
#   end

# def initialize(attributes={})
#    attributes.each do |k,v|
#      respond_to?(:"#{k}=") ? send(:"#{k}=", v) : raise(NoMethodError, "Unknown method #{k}, add it to the record attributes")
#    end
#  end
