require 'eventful'
require 'uuidtools'
require 'active_support'
require 'active_support/core_ext/object/returning'
# require 'validatable'
require 'yajl'

require 'support/guid'
require 'support/serialization'
require 'support/initializer'

require 'event_store/domain_event_storage'
require 'event_store/domain_repository'
require 'event_store/adapters/active_record_adapter'

require 'bus/router'
require 'bus/command_bus'
require 'bus/event_bus'

require 'commands/base_command'
require 'commands/handlers/base_command_handler'

require 'events/domain_event'
require 'events/handlers/base_handler'

require 'domain/base_aggregate_root'

# App
require 'commands/create_company_command'
require 'commands/handlers/create_company_handler'
require 'events/company_created_event'
require 'events/invoice_created_event'
require 'events/handlers/company_created_handler'
require 'domain/invoice'
require 'domain/company'
require 'reporting/company'