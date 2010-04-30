module Commands
  module ActiveModel
    def self.extended(base)
      base.class_eval do
        include ::ActiveModel::Conversion
        include ::ActiveModel::AttributeMethods
        include ::ActiveModel::Validations
        
        extend ::Rcqrs::Initializer        
        include Commands::ActiveModel
      end
    end

    # Commands are never persisted
    def persisted?
      false
    end

    # def to_key
    #   nil
    # end
    # 
    # def to_model
    #   self
    # end
  end
end