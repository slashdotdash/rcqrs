module Commands
  class InvalidCommand < StandardError; end
  class MissingHandler < StandardError; end
  
  class BaseCommand
    extend Rcqrs::Initializer
    include Validatable
  end
end