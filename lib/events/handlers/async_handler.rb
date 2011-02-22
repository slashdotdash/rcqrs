module Events
  module Handlers
    class AsyncHandler < BaseHandler
      def self.perform(event_class_name, event_json)
        event = event_class_name.constantize.from_json(event_json)
        self.new.execute(event)
      end
    end
  end
end