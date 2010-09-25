# Ruby CQRS with Event Sourcing

A Ruby implementation of Command-Query Responsibility Segregation (CQRS) with Event Sourcing, based upon the ideas of [Greg Young](http://codebetter.com/blogs/gregyoung/).

[Find out more about CQRS](http://cqrsinfo.com/).

## Getting Started

Dependencies are managed using [Bundler](http://gembundler.com/).

    $ sudo gem install bundler

Install all of the required gems for this application

    $ sudo bundle install

## Specs

Run the RSpec specifications as follows.

    $ spec spec/

## Basic Design Overview

###UI

- display query results
- create commands - must be 'task focused'
- basic validation of command (e.g. required fields, uniqueness using queries against the reporting data store)

###Commands
such as `RegisterCompanyCommand`

- capture users’ intent
- named in the imperative (e.g. create account, upgrade customer, complete checkout)
- can fail / declined

###Command Bus

- validates command
- routes command to registered handler

###Command Handler 
such as `RegisterCompanyHandler`

- loads corresponding aggregate root (using domain repository)
- executes action on aggregate root
  
###Aggregate Roots
such as `Company`

- guard clause (raises exceptions when invalid commands applied)
- calculations (but no state changes)
- create & raise corresponding domain events
- subscribes to domain events to update internal state

###Domain Events
such as `CompanyRegisteredEvent`

- inform something that has already happened
- must be in the past tense and cannot fail
- used to update internal state of the corresponding aggregate root
  
###Event Bus

- suscribes to domain events
- persist domain events to event store
- routes events to registered handler(s)

###Event Handler
such as `CompanyRegisteredHandler`

- update de-normalised reporting data store(s)
- email sending
- execute long running processes (e.g. 3rd party APIs, file upload)

###Event Store

- persists all domain events applied to each aggregate root (stored as JSON)
- reconstitutes aggregate roots from events (from serialised JSON)
- currently two adapters: ActiveRecord and in memory (for testing)
- adapter interface is 2 methods: `find(guid)` and `save(aggregate_root)`
- could be extended to use a NoSQL store