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
          # raise AggregateConcurrencyError unless aggregate.version == provider.version

          save_events(aggregate.applied_events)
          
          provider.update_attribute(:version, aggregate.version)
        end
      end
      
      def connection
        ActiveRecord::Base.connection
      end

    private
      
      def find_or_create_provider(aggregate)
        EventProvider.find(aggregate.guid) || create_provider(aggregate)
      end
      
      def create_provider(aggregate)
        EventProvider.create!(
          :aggregate_id => aggregate.guid,
          :aggregate_type => aggregate.class.name,
          :version => 0)
      end

      def save_events(events)
        Event.transaction do
          events.each do |event|
            Event.create!(
              :aggregate_id => event.aggregate_id,
              :version => event.version,
              :data => event.attributes_to_json)
          end
        end
      end
      
      def establish_connection(options)
        ActiveRecord::Base.establish_connection(options)
      end

      def ensure_tables_exist
        ensure_event_providers_table_exists
        ensure_events_table_exists
      end
      
      def ensure_event_providers_table_exists
        return if EventProvider.table_exists?
        
        connection.create_table(:event_providers, :primary_key => false) do |t|
          t.column :aggregate_id, :string, :null => false
          t.column :aggregate_type, :string, :null => false
          t.column :version, :integer, :null => false
          t.column :created_at, :timestamp, :null => false
        end

        connection.add_index :event_providers, :aggregate_id, :unique => true
      end
      
      def ensure_events_table_exists
        return if Event.table_exists?
        
        connection.create_table(:events, :primary_key => false) do |t|
          t.column :aggregate_id, :string, :null => false
          t.column :version, :integer, :null => false
          t.column :data, :blob, :null => false
          t.column :created_at, :timestamp, :null => false
        end
        
        connection.add_index :events, :aggregate_id
        connection.add_index :events, [:aggregate_id, :version]
      end
    end
  end
end