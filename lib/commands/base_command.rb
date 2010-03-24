module Commands
  class BaseCommand
    extend Rcqrs::Initializer
    include Validatable
  end
end