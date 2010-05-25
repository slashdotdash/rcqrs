module Rcqrs
  module Serialization
    def self.included(base)
      base.extend ClassMethods
    end
    
    def to_json(attributes=self.attributes)
      Yajl::Encoder.encode(attributes)
    end

    module ClassMethods
      def from_json(json)
        parsed = Yajl::Parser.parse(json)
        self.new(parsed)
      end
    end
  end
end