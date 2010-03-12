module Rcqrs
  module Serialization
    def to_json
      h = {}
      instance_variables.each do |e|
        o = instance_variable_get e.to_sym
        h[e[1..-1]] = (o.respond_to? :to_json) ? o.to_json : o;
      end

      ActiveSupport::JSON.encode(h)      
    end

    def from_json(json)
      ActiveSupport::JSON.decode(json).each do |key, value|
        instance_variable_set "@#{key}".to_sym, ActiveSupport::JSON.decode(value)
      end
      self
    end
  end
end