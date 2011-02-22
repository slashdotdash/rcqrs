module Bus
  class AsyncEventBus
    def initialize(router)
      require_resque
      @router = router
    end

    # Publish event to registered handlers to be executed asynchronously using resque
    def publish(event)
      @router.handlers_for(event).each do |handler|
        if handler.is_a?(Events::Handlers::AsyncHandler)
          execute_async(handler, event)
        else
          execute_immediate(handler, event)
        end
      end
    end
    
  private
    
    def execute_async(handler, event)
      Resque::Job.create('rcqrs', handler.class, event.class.to_s, event.to_json)
    end
    
    def execute_immediate(handler, event)
      handler.execute(event)
    end
      
    def require_resque
      unless defined? Resque
        begin
          require 'resque'
        rescue LoadError
          raise "Missing the 'resque' gem. Add it to your Gemfile: gem 'resque'"
        end
      end
    end
  end
end