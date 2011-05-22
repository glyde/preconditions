require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class IncludingClass
  include Preconditions
end

[Preconditions, IncludingClass, IncludingClass.new].each do |s|

  describe "precondition checks on #{s}" do
    subject { s }

    it "raises an ArgumentError when checking for nil on a nil value" do
      expect { subject.check_not_nil(nil) }.to raise_exception ArgumentError
    end
    
    it "returns the argument in a nil check when argument is not nil" do
      subject.check_not_nil(1).should == 1
    end
    
    it "raises an ArgumentError with message when checking for nil with a supplied message" do
      expect { subject.check_not_nil(nil, "expected message") }.
        to raise_exception(ArgumentError, "expected message")
    end
    
    it "raises an ArgumentError with formatted message when checking for nil with a formatted message" do
      expect { subject.check_not_nil(nil, "expected message is %s (%d)", "awesome", 10) }.
        to raise_exception(ArgumentError, "expected message is awesome (10)")
    end


    it "raises an ArgumentError when checking an argument expression that is false" do
      expect { subject.check_argument(false) }.
        to raise_exception ArgumentError
    end

    it "returns the expression result when expression is true" do
      subject.check_argument(true).should == true
    end

    it "raises an ArgumentError when checking a block that yields false" do
      expect { subject.check_block { false } }.
        to raise_exception ArgumentError
    end

    it "returns the block evaluation result when evaluation is true" do
      subject.check_block { true }.should == true
    end

    it "raises a TypeError when argument is not of required type" do
      expect { subject.check_type(1, String) }.
        to raise_exception TypeError
    end

    it "returns the argument in a type check when the type is equal" do
      subject.check_type(1, Fixnum).should == 1
    end

    it "returns the argument in a type check when the type is compatible" do
      subject.check_type(1, Integer).should == 1
    end

    it "returns the argument in a type check when the type is nil" do
      subject.check_type(nil, Integer).should == nil
    end

    it "raises a NameError when argument does not support requested method" do
      expect { subject.check_responds_to(1, :no_such_method) }.
        to raise_exception
    end

    it "returns the argument when it supports the requested method" do
      subject.check_responds_to(1, :succ).should == 1
    end
  end

end
