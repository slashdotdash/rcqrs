module Commands
  module ActiveModel
    def self.extended(base)
      base.class_eval do
        include ::ActiveModel::Conversion
        include ::ActiveModel::AttributeMethods
        include ::ActiveModel::Validations
        extend ::ActiveModel::Naming
        
        extend ::Rcqrs::Initializer
        include Commands::ActiveModel
      end
    end

    def parse_date(date)
      return date.to_date if date.is_a?(Date) || date.is_a?(DateTime) || date.is_a?(ActiveSupport::TimeWithZone)
      return nil if date.blank?
      
      return DateTime.strptime(date, '%d/%m/%Y').to_date
    rescue
      return date
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