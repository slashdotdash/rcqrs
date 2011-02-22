class MockAsyncHandler < Events::Handlers::AsyncHandler
  attr_reader :handled

  def execute(event_or_command)
    @handled = true
  end
end