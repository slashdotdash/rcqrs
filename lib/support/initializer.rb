module Rcqrs
  module Initializer
    attr_accessor :initializer_attributes
    
    def initializer(*args, &block)
      initializer_attributes = args.dup
      last = (initializer_attributes.last.is_a?(Hash) ? initializer_attributes.pop : {})
      if last[:attr_reader] == true
        initializer_attributes.each do |attr|
          send(:attr_reader, attr)
        end
      end

      define_method :initialize do |*ctor_args|
        ctor_named_args = (ctor_args.last.is_a?(Hash) ? ctor_args.pop : {})
        initializer_attributes.each_with_index do |arg, index|
          instance_variable_set("@#{arg}", ctor_args[index])
        end

        ctor_named_args.each_pair do |param_name, param_value|
          raise(ArgumentError, "Unknown method #{param_name}, add it to the record attributes") unless respond_to?(:"#{param_name}")
          instance_variable_set("@#{param_name}", param_value)
        end
        
        initialize_behavior if block_given?
      end

      define_method :initialize_behavior, &block if block_given?  
      
      # Get all attributes defined in the initializer as a hash      
      define_method :attributes do
        (initializer_attributes || []).inject({}) do |attrs, attribute|
          attrs.merge!(attribute.to_sym => instance_variable_get("@#{attribute}"))
        end
      end
      
      define_method :attributes_to_json do
        to_json(attributes)
      end
    end
  end
end