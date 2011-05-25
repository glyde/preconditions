require 'condition_checker'

module Preconditions

  module PreconditionMixinMethods

    # Check that arg is not nil, raising an ArgumentError with an optional
    # message and format if it is nil
    # @param arg the argument to check
    # @param msg optional format string message to print
    # @param fmt arguments to format into format string
    # @raise [ArgumentError] if the arg is nil
    def check_not_nil(arg, msg = nil, *fmt)
      if arg.nil?
        raise_exception(ArgumentError, msg, *fmt)
      end
      arg
    end

    # Check that given expression is satisfied. Should be used in the context of
    # an checking an argument, though this is not strictly required.
    # @param exp a boolean expression; if true, the argument is good, if false it is not
    # @param msg optional format string message to print
    # @param fmt arguments to format into format string
    # @raise [ArgumentError] if exp is false
    def check_argument(exp, msg = nil, *fmt)
      if !exp
        raise_exception(ArgumentError, msg, *fmt)
      end
      exp
    end


    # Check that given block expression is satisfied. Should be used in the context of
    # an checking an argument, though this is not strictly required.
    # @param msg optional format string message to print
    # @param fmt arguments to format into format string
    # @raise [ArgumentError] if block evaluates to false
    def check_block(msg = nil, *fmt, &block)
      res = yield
      if !res
        raise_exception(ArgumentError, msg, *fmt)
      end
      res
    end

    # Check that given object is of given type.
    # @param obj object to check
    # @param expected_type type of which object is expected to be an instance
    # @param msg optional format string message to print
    # @param fmt arguments to format into format string
    # @return obj
    # @raise [TypeError] if obj is not an instance of expected_type
    def check_type(obj, expected_type, msg=nil, *fmt)
      if !obj.nil? && !obj.kind_of?(expected_type)
        raise_exception(TypeError, msg, *fmt)
      end
      obj
    end

    # Check that given object responds to given method
    # @param obj object to check
    # @param meth_sym symbolic name of method
    # @param msg optional format string message to print
    # @param fmt arguments to format into format string
    # @return obj
    # @raise [NameError] if meth_sym is not a method on obj
    def check_responds_to(obj, meth_sym, msg=nil, *fmt)
      if !obj.respond_to?(meth_sym)
        raise_exception(NameError, msg, *fmt)
      end
      obj
    end

    def self.included(receiver)
      receiver.extend PreconditionMixinMethods
    end

    private

    def raise_exception(e, msg, *fmt)
      message = if !fmt.empty?
                  sprintf(msg, *fmt)
                elsif !msg.nil?
                  msg
                else
                  ''
                end
      raise e, message
    end
  end

  module PreconditionModuleClassMethods
    # Introduce a DSL expression to check the given argument, with the optionally given name.  This will return a
    #[ConditionChecker] instance that can be used to build the DSL expression.
    def check(argument, name = nil, &block)
      cc = ConditionChecker.new(argument, name)
      if block_given?
        cc.instance_eval(&block)
        argument # return the argument if a block is given to evaluate the check immediately
      else
        cc # return the checker if no evaluation block is supplied
      end
    end
  end

  class << self
    include PreconditionMixinMethods
    include PreconditionModuleClassMethods
  end

  def self.included(receiver)
    receiver.send :include, PreconditionMixinMethods
  end
end
