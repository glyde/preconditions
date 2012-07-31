require 'rspec'
require 'preconditions'

describe "dsl expression" do

  it "should pass with no checks in the is() block" do
    arg = 1
    res = Preconditions.check(arg) {}
    res.should == arg
  end

  it "should pass with no is() call" do
    arg = 1
    res = Preconditions.check(arg)
    # res will be a ConditionChecker instance, but should not have raised an exception
  end

  it "should raise on a failing condition check" do
    arg = nil
    expect {
      Preconditions.check(arg, 'arg') { is_not_nil }
    }.to raise_exception(ArgumentError)
  end

  it "should raise on a failing condition check in a conjugated list" do
    arg = 1
    expect {
      Preconditions.check(arg, 'arg') { is_not_nil and has_type(String) }
    }.to raise_exception(TypeError)
  end

  it "should return the argument if all condition checks pass" do
    arg = 1
    res = Preconditions.check(arg, 'arg') { is_not_nil and has_type(Integer) }
    res.should == arg
  end

  it 'should raise on a matches check if the regex does not match' do
    arg = 'some string'
    expect {
      Preconditions.check(arg) { matches(/other thing/) }
    }.to raise_exception(ArgumentError)
  end

  it 'should return true on a matches check if the regex does match' do
    arg = 'some string'
    res = Preconditions.check(arg) { matches(/me/) }
    res.should == arg
  end

  it "should evaluate a satisfies block using the instance-local arg value" do
    x = 1
    expect {
      Preconditions.check(x, 'x') { is_not_nil and satisfies("less than zero") { arg <= 0 } }
    }.to raise_exception(ArgumentError, "Argument 'x' must be less than zero")
  end

  it "should pass argument in to yielded satisfies block if requested" do
    x = 1
    expect {
      Preconditions.check(x, 'x') { is_not_nil and satisfies("less than zero") { |v| v <= 0 } }
    }.to raise_exception(ArgumentError, "Argument 'x' must be less than zero")
  end

  it "should evaluate a satisfies block binding in the arg name as an accessible variable" do
    x = 1
    expect {
      Preconditions.check(x, 'x') { is_not_nil and satisfies("less than zero") { x <= 0 } }
    }.to raise_exception(ArgumentError, "Argument 'x' must be less than zero")
  end

  it "should allow for name specification using the 'named' method" do
    x = 1
    expect {
      Preconditions.check(x).named('x') { is_not_nil and satisfies("<= 0") { x <= 0 } }
    }.to raise_exception(ArgumentError, "Argument 'x' must be <= 0")
  end

end