module Rcqrs
  module Serialization
    def self.included(base)
      base.extend ClassMethods
    end
    
    def to_json
      Yajl::Encoder.encode(self)
    end
    
    module ClassMethods
      def from_json(json)
        parsed = Yajl::Parser.parse(json)
        parsed.delete("")
        self.new(parsed)
      end
    end
    
    # def to_json
    #   h = {}
    #   instance_variables.each do |e|
    #     o = instance_variable_get e.to_sym
    #     h[e[1..-1]] = (o.respond_to? :to_json) ? o.to_json : o;
    #   end
    # 
    #   ActiveSupport::JSON.encode(h)      
    # end
    # 
    # def from_json(json)
    #   ActiveSupport::JSON.decode(json).each do |key, value|
    #     instance_variable_set "@#{key}".to_sym, ActiveSupport::JSON.decode(value)
    #   end
    #   self
    # end
  end
end