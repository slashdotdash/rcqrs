require File.join(File.dirname(__FILE__), 'spec_helper')

module Rcqrs
  class Car
    extend Initializer
    include Serialization
    
    attr_reader :manufacturer, :model, :bhp, :ps

    initializer :manufacturer, :model, :bhp do
      @ps = bhp.to_f / 2
    end
  end
  
  class Bike
    extend Initializer
    initializer :manufacturer, :attr_reader => true 
  end

  describe Initializer do
    context "when creating with positional arguments" do
      before(:each) do
        @car = Car.new('Ford', 'Focus', 115)
      end
    
      it "should set the manufacturer" do
        @car.manufacturer.should == 'Ford'
      end
      
      it "should set the manufacturer" do
        @car.model.should == 'Focus'
      end
      
      it "should set the bhp and ps from power" do
        @car.bhp.should == 115
        @car.ps.should == 57.5
      end
    end
    
    context "when creating with named arguments" do
      before(:each) do
        @car = Car.new(:model => 'Focus', :manufacturer => 'Ford')
      end
    
      it "should set the manufacturer" do
        @car.manufacturer.should == 'Ford'
      end
      
      it "should set the manufacturer" do
        @car.model.should == 'Focus'
      end      
    end
    
    context "when creating with arguments hash" do
      before(:each) do
        arguments = { :manufacturer => 'Ford', :model => 'Focus' }
        @car = Car.new(arguments)
      end
    
      it "should set the manufacturer" do
        @car.manufacturer.should == 'Ford'
      end
      
      it "should set the manufacturer" do
        @car.model.should == 'Focus'
      end
    end
  
    context "when creating with invalid parameter" do
      it "should raise an exception" do
        proc { Car.new(:invalid => 'x') }.should raise_error(ArgumentError)
      end
    end
  
    context "when getting the attributes" do
      before(:each) do
        @car = Car.new(:manufacturer => 'Ford', :model => 'Focus', :bhp => 115)
      end
    
      it "should return hash of all attributes" do
        @car.attributes.should == { :manufacturer => 'Ford', :model => 'Focus', :bhp => 115 }
      end

      it "should allow creation of new object from existing object's attributes" do
        cloned = Car.new(@car.attributes)
        cloned.manufacturer.should == 'Ford'
      end
    end
  
    context "when defining attrs automatically" do
      before(:each) do
        @bike = Bike.new('Planet X')
      end
    
      it "should have attr_reader defined" do
        @bike.manufacturer.should == 'Planet X'
      end
    end
    
    context "when initializing from another initialized object with attributes" do
      before (:each) do
        @bike = Bike.new('Planet X')
        @car = Car.new(@bike)
      end
      
      it "should set manufacturer" do
        @car.manufacturer.should == @bike.manufacturer
      end
    end
    
    context "when serializing to JSON" do
      before(:each) do
        @car = Car.new(:model => 'Focus', :manufacturer => 'Ford')
        @json = @car.to_json
        @decoded = Yajl::Parser.parse(@json)
      end
      
      it "should serialize all instance variables" do
        @decoded.keys.sort.should == %w(manufacturer model ps)
      end
      
      it "should serialize all values" do
        @decoded['manufacturer'].should == @car.manufacturer
        @decoded['model'].should == @car.model
        @decoded['ps'].should == @car.ps
      end
    end
  end
end