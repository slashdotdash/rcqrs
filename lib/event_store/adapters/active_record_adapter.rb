require 'active_record'

module EventStore
  module Adapters
    class Event < ActiveRecord::Base
      scope :for_aggregate, lambda { |guid|
        { :conditions => { :aggregate_id => guid }, :order => :version }}
    end

    class ActiveRecordAdapter
      def initialize(options={})
        options.reverse_merge!(:adapter => 'sqlite3', :database => 'events.db')
        establish_connection(options)
        ensure_table_exists
      end
      
      def find(guid)
        Event.for_aggregate(guid)
      end

      def save(events)
        Event.transaction do
          events.each do |event|
            Event.create!(
              :aggregate_id => event.aggregate_id, 
              :aggregate_class => event.aggregate_class,
              :version => event.version,
              :data => event.attributes_to_json)
          end
        end
      end
      
      def connection
        ActiveRecord::Base.connection
      end

    private

      def establish_connection(options)
        ActiveRecord::Base.establish_connection(options)
      end
      
      def ensure_table_exists
        return if Event.table_exists?
        
        ActiveRecord::Base.connection.create_table(:events) do |t|
          t.column :aggregate_id, :string
          t.column :aggregate_class, :string
          t.column :version, :integer
          t.column :data, :blob
          t.column :created_at, :timestamp
        end
      end
    end
  end
end