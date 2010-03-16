require File.join(File.dirname(__FILE__), '/../lib/cqrs')

module Rcqrs
  class Car
    extend Initializer
    
    attr_reader :manufacturer, :make, :bhp, :ps

    initializer :manufacturer, :make, :bhp do
      @ps = bhp.to_f / 2
    end
  end
    
  describe Car do
    context "when creating with positional arguments" do
      before(:each) do
        @car = Car.new('Ford', 'Focus', 115)
      end
    
      it "should set the manufacturer" do
        @car.manufacturer.should == 'Ford'
      end
      
      it "should set the manufacturer" do
        @car.make.should == 'Focus'
      end
      
      it "should set the bhp and ps from power" do
        @car.bhp.should == 115
        @car.ps.should == 57.5
      end
    end
    
    context "when creating with named arguments" do
      before(:each) do
        @car = Car.new(:make => 'Focus', :manufacturer => 'Ford')
      end
    
      it "should set the manufacturer" do
        @car.manufacturer.should == 'Ford'
      end
      
      it "should set the manufacturer" do
        @car.make.should == 'Focus'
      end      
    end
    
    context "when creating with arguments hash" do
      before(:each) do
        arguments = { :manufacturer => 'Ford', :make => 'Focus' }
        @car = Car.new(arguments)
      end
    
      it "should set the manufacturer" do
        @car.manufacturer.should == 'Ford'
      end
      
      it "should set the manufacturer" do
        @car.make.should == 'Focus'
      end
    end
  end
  
  context "when creating with invalid parameter" do
    it "should raise an exception" do
      proc { Car.new(:invalid => 'x') }.should raise_error(ArgumentError)
    end
  end
  
  context "when getting the attributes" do
    before(:each) do
      @car = Car.new(:manufacturer => 'Ford', :make => 'Focus', :bhp => 115)
    end
    
    it "should return hash of all attributes" do
      @car.attributes.should == { :manufacturer => 'Ford', :make => 'Focus', :bhp => 115 }
    end
    
    it "should allow creation of new object from existing object's attributes" do
      cloned = Car.new(@car.attributes)
      cloned.manufacturer.should == 'Ford'
    end
  end
end