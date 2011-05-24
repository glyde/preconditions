# Preconditions #

A simple package to make the testing of method arguments easier to write and
easier to read, inspired by <a
href="http://guava-libraries.googlecode.com/svn-history/r13/trunk/javadoc/com/google/common/base/Preconditions.html">Guava's
Preconditions</a> class

## Overview ##

The preconditions package provides a single module, `Preconditions`, which in turn provides a number of methods to check
the validity of method arguments.  Two API styles are provided: a standard "command query" interface, where each check
is a single method call with an optional message format, and a fluent DSL interface, where checks are built up using
a more natural language.

## Usage ##

To use the command-query API you can access the `check_XXX` methods directly through the Preconditions module, like so:

    class MyMath
      def sqrt(num)
        Preconditions.check_not_nil(num)
        Preconditions.check_type(num, Integer, "num argument must be an integer: non integer types are unsupported")
        Preconditions.check_argument(num >= 0, "num argument must be greater than zero")
        num.sqrt
      end
    end

You can also `include Preconditions` to import the command-query calls into your class for use without the
`Preconditions` module prefix.  The full list of command-query calls is documented in the `Preconditions` module itself.

To use the fluent DSL API use the `check(arg).is {}` form like so:

    class MyMath
      def sqrt(num)
        Preconditions.check(num) { is_not_nil and has_type(Integer) and satisfies(">= 0") { arg >= 0 } }
        num.sqrt
      end
    end

Note that there is less opportunity for custom messaging in the fluent API.  However, a second argument to `check` can
be supplied to add the argument name to any raised errors:

    class MyMath
      def sqrt(num)
        Preconditions.check(num, 'num') { is_not_nil and has_type(Integer) and satisfies(">= 0") { arg >= 0 } }
        num.sqrt
      end
    end

In this case, if `num` is the value -10 then an [ArgumentError] will be raised with a message along the lines of
"Argument 'num' must be >= 0, but was -10".

The set of available checks is documented in the `ConditionChecker` documentation.

The `check` method on the fluent API will not be imported when the `Preconditions` module is included: it can only be
addressed with the `Preconditions` prefix.  This is to prevent possible name clashes with existing `check` methods in
client code (check being a somewhat common verb).  The use of `and` as a separator in the DSL expression is purely
for readability: newlines and semi-colons work just as well (all DSL methods either raise an exception or return true).


## Contributing to preconditions ##
 
* Check out the latest master to make sure the feature hasn't been implemented
  or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it
  and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want
  to have your own version, or is otherwise necessary, that is fine, but
  please isolate to its own commit so I can cherry-pick around it.

## Copyright ##

Copyright (c) 2011 Chris Tucker. See LICENSE.txt for further details.
