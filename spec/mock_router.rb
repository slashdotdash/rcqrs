class MockRouter
  include Eventful
  attr_reader :handled
  
  def handler_for(event_or_command, repository)
    self
  end
  
  def execute(event_or_command)
    simulate_raising_domain_event
    @handled = true
  end
  
private

  def simulate_raising_domain_event
    Eventful.fire(:domain_event, nil)
  end
end