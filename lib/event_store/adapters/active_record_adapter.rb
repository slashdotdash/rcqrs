require 'active_record'

module EventStore
  module Adapters
    # Represents every aggregate created
    class EventProvider < ActiveRecord::Base
      def self.find(guid)
        return nil if guid.blank?
        where(:aggregate_id => guid).first
      end
      
      def events
        Event.for(aggregate_id)
      end
    end

    class Event < ActiveRecord::Base
      scope :for, lambda { |guid| where(:aggregate_id => guid).order(:version) }
    end

    class ActiveRecordAdapter < EventStore::DomainEventStorage
      def initialize(options={})
        options.reverse_merge!(:adapter => 'sqlite3', :database => 'events.db')
        establish_connection(options)
        ensure_tables_exist
      end
      
      def find(guid)
        EventProvider.find(guid)
      end

      def save(aggregate)
        provider = find_or_create_provider(aggregate)
        save_events(aggregate.pending_events)
        provider.update_attribute(:version, aggregate.version)
      end
      
      def transaction(&block)
        ActiveRecord::Base.transaction do
          yield
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
          provider = create_provider(aggregate)
        end
        provider
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
            :event_type => event.class.name,
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
        
        # no primary key as we do not update or delete from this table
        event_connection.create_table(:events, :id => false) do |t|
          t.string :aggregate_id, :limit => 36, :null => false
          t.string :event_type, :null => false
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