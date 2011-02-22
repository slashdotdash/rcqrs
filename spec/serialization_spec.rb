require File.join(File.dirname(__FILE__), 'spec_helper')

module Rcqrs
  class SerializableCar
    extend Initializer
    include Serialization

    attr_accessor :engine_size
    initializer :manufacturer, :model, :attr_reader => true
  end


  describe Serialization do
    before(:each) do
      @car = SerializableCar.new(:manufacturer => 'Ford', :model => 'Focus')
      @car.engine_size = 2.0
      @json = @car.to_json
      @decoded = Yajl::Parser.parse(@json)
    end
    
    it "should serialize all instance variables" do
      @decoded.keys.sort.should == %w(engine_size manufacturer model)
    end
    
    it "should serialize all values" do
      @decoded['manufacturer'].should == @car.manufacturer
      @decoded['model'].should == @car.model
      @decoded['engine_size'].should == @car.engine_size
    end
  end
end