# The ConditionChecker supplied the DSL host environment to evaluate expressions in the Preconditions DSL language.
# The #is method takes a block that is evaluated in the context of the ConditionChecker instance, with access to all
# of the ConditionChecker methods.  Typical usage will be of the form:
#
#    Preconditions.check(x).is { not_nil and responds_to(:hello)
#
class ConditionChecker

  attr_reader :arg, :name

  def initialize(arg, name=nil, &block)
    @arg = arg
    @name = name
  end

  # Set the name of the argument being checked
  # @param name [String] the name of the parameter being checked
  # @return argument if a block is given to evaluate, or self if not to allow for further method chaining
  # @raises if a block is given and the validation rules specified therein are not met
  def named(name, &block)
    @name = name
    if block_given?
      instance_eval(&block)
      arg
    else
      self
    end
  end

  # DSL call.  Establishes that the checked argument is non-nil.
  # @raises [ArgumentError] if the argument is nil
  # @return true
  def is_not_nil
    if arg.nil?
      raise ArgumentError, format_message("may not be nil")
    end
    true
  end

  # DSL call.  Establishes that the checked argument is of the given type.  nil is treated as a bottom type (i.e. it
  # is compatible with all types)
  # @raises [TypeError] if the argument is not type-compatible with the argument
  # @return true
  def has_type(type)
    if !arg.nil? && !arg.kind_of?(type)
      raise TypeError, format_message("must be of type #{type.name}, but is of type #{arg.class.name}")
    end
    true
  end

  # DSL call.  Establishes that the checked argument can respond to the requested method, identified by symbol.
  # @raises [NameError] if the argument cannot respond to the supplied method name
  # @return true
  def can_respond_to(method_symbol)
    if !arg.respond_to?(method_symbol)
      raise NameError, format_message("must respond to method #{method_symbol}")
    end
    true
  end

  # DSL call.  Establishes that the checked argument satisfies an arbitrary condition specified in a block.  If the
  # block evaluates to true the argument passes; if it evaluates to false it fails and an [ArgumentError] is raised.
  # An optional message may be supplied to describe what the block is checking.
  #
  # If the block requests a bound variable that variable will be assigned the value of the argument we're checking.  The
  # block may also access the argument value using the `arg` name.  Note, also, that the block is a closure and will
  # have natural access to variables in lexical scope at the time the DSL expression is created.  Thus, one can do
  # something like:
  #    def sqrt(num)
  #       Preconditions.check(num) { satisfies { num >= 0 } }
  #    end
  def satisfies(msg = nil, &block)
    success = if block.arity > 0
                yield(arg)
              else
                instance_eval(&block)
              end
    if !success
      raise ArgumentError, msg.nil? ? format_message("must satisfy given conditions") : format_message("must be #{msg}")
    end
    true
  end

  private

  def format_message(message)
    name_str = if name
                 "'#{name}' "
               else
                 ''
               end
    "Argument #{name_str}#{message}"
  end

end
