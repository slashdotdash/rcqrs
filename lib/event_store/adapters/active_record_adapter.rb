require 'active_record'

module EventStore  
  module Adapters
    # Represents every aggregate created
    class EventProvider < ActiveRecord::Base
      def self.find(guid)
        where('aggregate_id = ?', guid).first
      end
    end

    class Event < ActiveRecord::Base
      scope :for, lambda { |guid| where('aggregate_id = ?', guid).order(:version) }
    end

    class ActiveRecordAdapter
      def initialize(options={})
        options.reverse_merge!(:adapter => 'sqlite3', :database => 'events.db')
        establish_connection(options)
        ensure_tables_exist
      end
      
      def find(guid)
       provider = EventProvider.find(guid)
       raise AggregateNotFound if provider.nil?

       [provider.aggregate_type, Event.for(guid)]
      end

      def save(aggregate)
        EventProvider.transaction do
          provider = find_or_create_provider(aggregate)          

          save_events(aggregate.pending_events)
          
          provider.update_attribute(:version, aggregate.version)
        end
      end
      
      def provider_connection
        EventProvider.connection
      end
      
      def event_connection
        Event.connection
      end

    private
      
      def find_or_create_provider(aggregate)
        if provider = EventProvider.find(aggregate.guid)
          raise AggregateConcurrencyError unless provider.version == aggregate.source_version
        else
          create_provider(aggregate)
        end
      end

      def create_provider(aggregate)
        EventProvider.create!(
          :aggregate_id => aggregate.guid,
          :aggregate_type => aggregate.class.name,
          :version => 0)
      end

      def save_events(events)
        events.each do |event|
          Event.create!(
            :aggregate_id => event.aggregate_id,
            :version => event.version,
            :data => event.attributes_to_json)
        end
      end
      
      # Connect to a different database for event storage models
      def establish_connection(options)
        EventProvider.establish_connection(options)
        Event.establish_connection(options)
      end

      def ensure_tables_exist
        ensure_event_providers_table_exists
        ensure_events_table_exists
      end
      
      def ensure_event_providers_table_exists
        return if EventProvider.table_exists?
        
        provider_connection.create_table(:event_providers) do |t|
          t.string :aggregate_id, :limit => 36, :primary => true
          t.string :aggregate_type, :null => false
          t.integer :version, :null => false
          t.timestamps
        end

        provider_connection.add_index :event_providers, :aggregate_id, :unique => true
      end
      
      def ensure_events_table_exists
        return if Event.table_exists?
        
        event_connection.create_table(:events, :id => false) do |t|
          t.string :aggregate_id, :limit => 36, :null => false
          t.integer :version, :null => false
          t.text :data, :null => false
          t.timestamp :created_at, :null => false
        end
        
        event_connection.add_index :events, :aggregate_id
        event_connection.add_index :events, [:aggregate_id, :version]
      end
    end
  end
end