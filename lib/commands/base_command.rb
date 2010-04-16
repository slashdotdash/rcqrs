module Commands
  class InvalidCommand < StandardError; end
  
  class BaseCommand
    extend Rcqrs::Initializer
    include ActiveModel::Validations
  end
end