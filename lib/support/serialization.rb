require 'yajl'
require 'yajl/json_gem'

module Rcqrs
  module Serialization
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def from_json(json)
        parsed = Yajl::Parser.parse(json)
        self.new(parsed)
      end
    end
  end
end