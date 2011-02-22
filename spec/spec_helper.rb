require 'rubygems'
require 'bundler'

Bundler.setup(:default, :spec)

require File.join(File.dirname(__FILE__), '/../lib/rcqrs')

require 'bus/mock_router'
require 'bus/mock_async_handler'
require 'commands/create_company_command'
require 'commands/handlers/create_company_handler'
require 'events/company_created_event'
require 'events/invoice_created_event'
require 'events/handlers/company_created_handler'
require 'domain/invoice'
require 'domain/company'
require 'reporting/company'