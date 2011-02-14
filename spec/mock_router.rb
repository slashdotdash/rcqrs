class MockRouter
  attr_reader :handled
  
  def handler_for(command, repository)
    self
  end

  def handlers_for(event)
    [ self ]
  end
  
  def execute(event_or_command)
    @handled = true
  end
end