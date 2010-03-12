require 'eventful'
require 'uuidtools'
require 'active_support'

class Module
  def initializer(*args, &block)
    define_method :initialize do |*ctor_args|
      ctor_named_args = (ctor_args.last.is_a?(Hash) ? ctor_args.pop : {})
      (0..args.size).each do |index|
        instance_variable_set("@#{args[index]}", ctor_args[index])
      end

      ctor_named_args.each_pair do |param_name, param_value|
        raise(NoMethodError, "Unknown method #{param_name}, add it to the record attributes") unless respond_to?(:"#{param_name}") 
        instance_variable_set("@#{param_name}", param_value) 
      end
      initialize_behavior if block_given?
    end
    
    define_method :initialize_behavior, &block if block_given?  
  end
end

require 'support/guid'
require 'support/serialization'

require 'events/domain_event'
require 'domain/base_aggregate_root'

require 'events/company_created_event'
require 'events/invoice_created_event'
require 'domain/invoice'
require 'domain/company'