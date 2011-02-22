class MockRouter
  attr_reader :handler, :handled
  
  def initialize(handler=self)
    @handler = handler
  end
  
  def handler_for(command, repository)
    @handler
  end

  def handlers_for(event)
    [ @handler ]
  end
  
  def self.perform(event_klass, event_json)
    # not supported
  end
  
  def execute(event_or_command)
    @handled = true
  end
end