module Rcqrs
  # == Rcqrs Initializer
  # 
  # <tt>Rcqrs::Initializer</tt> provides a way to easily initialize Ruby objects
  # using named or positional arguments to the constructor
  # 
  # Example:
  # 
  #    class Car
  #      extend Initializer
  #      attr_reader :manufacturer, :model
  #    end
  # 
  # Provides you with:
  # 
  #    car = Car.new('Ford', 'Focus')
  #    car = Car.new(:manufacturer => 'Ford', :model => 'Focus')
  #    car = Car.new do
  #      # custom initialize code goes here
  #    end
  # 
  module Initializer
    def self.extended(base)
      base.class_eval do
        include(InstanceMethods)
      end
    end
    
    # Initialize an object using either argument position or named arguments.
    # Last argument may be a hash of options such as :attr_reader => true
    def initializer(*args, &block)
      initializer_attributes = args.dup

      extract_last_arg_as_options!(initializer_attributes)

      define_method :initialize do |*ctor_args|
        ctor_named_args = (ctor_args.last.is_a?(Hash) ? ctor_args.pop : {})

        initialize_from_attributes(ctor_args)
        initialize_from_named_args(ctor_named_args)
        initialize_from_constructor_args_by_order(initializer_attributes, ctor_args)
        
        initialize_behavior if block_given?
      end

      define_method :initialize_behavior, &block if block_given?  
      
      # Get all attributes defined in the initializer as a hash      
      define_method :attributes do
        (initializer_attributes || []).inject({}) do |attrs, attribute|
          attrs.merge!(attribute.to_sym => instance_variable_get("@#{attribute}"))
        end
      end
    end
        
    def extract_last_arg_as_options!(args)
      last = (args.last.is_a?(Hash) ? args.pop : {})
      
      if last[:attr_reader] == true
        args.each do |attr|
          send(:attr_reader, attr)
        end
      end
    end
    
    module InstanceMethods
    
    private
    
      # allow creation of this object from another initializer object's attributes
      def initialize_from_attributes(ctor_args)
        if ctor_args.first.respond_to?(:attributes)
           obj = ctor_args.shift

           obj.attributes.each do |name, value|
             instance_variable_set("@#{name}", value)
           end
         end
      end

      def initialize_from_named_args(ctor_named_args)
        ctor_named_args.each_pair do |param_name, param_value|
          raise(ArgumentError, "Unknown method #{param_name}, add it to the record attributes") unless respond_to?(:"#{param_name}")
          instance_variable_set("@#{param_name}", param_value)
        end
      end
      
      def initialize_from_constructor_args_by_order(initializer_attributes, ctor_args)
        return if ctor_args.empty?

        initializer_attributes.each_with_index do |arg, index|
          instance_variable_set("@#{arg}", ctor_args[index])
        end
      end
    end
  end
end