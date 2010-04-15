module Commands
  class InvalidCommand < StandardError; end
  
  class BaseCommand
    extend Rcqrs::Initializer
    # include Validatable
    include ActiveModel::Validations
  end
end