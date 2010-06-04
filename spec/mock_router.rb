class MockRouter
  attr_reader :handled
  
  def handler_for(event_or_command, repository)
    self
  end
  
  def execute(event_or_command)
    @handled = true
  end
end