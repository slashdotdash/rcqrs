require 'eventful'
require 'uuidtools'
require 'active_support'

require 'support/guid'
require 'support/serialization'
require 'support/initializer'

require 'events/domain_event'
require 'domain/base_aggregate_root'

require 'events/company_created_event'
require 'events/invoice_created_event'
require 'domain/invoice'
require 'domain/company'