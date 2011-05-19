# Preconditions #

A simple package to make the testing of method arguments easier to write and
easier to read.

## Overview ##

The Preconditions package provides a single module, Preconditions, with methods for:

* Checking if an argument is nil
* Checking if an argument satisfies a boolean condition (e.g. x > 10)
* Checking if an argument responds to a certain method (duck typing)
* Checking if an argument is of a specific type (strict typing)

Each of these methods will raise an appropriate exception if the rule it is
applying is violated.

Preconditions can be checked either by using the `Preconditions` module
directly, as in `Preconditions::check_not_nil(x)`, or by mixing the
`Preconditions` module into your class to make the methods available without the
`Preconditions` prefix.  If the module is mixed in the precondition checking
methods will be available to both class and instance methods equivalently.

## Usage ##

To check for null arguments:

    def my_meth(arg)
      Preconditions.check_not_nil(arg)
      ...
    end

If you wish to supply a message simply include a string as your second
parameter:

    def my_meth(arg)
      Preconditions.check_not_nil(arg, "nil values are evil!")
      ...
    end

You can even use a format if you want to interpolate some variables into your
message lazily:

    def my_meth(arg)
      Preconditions.check_not_nil(arg, "Using nil in context of: %s", @bigobj.to_s)
      ...
    end

All methods support both a message and a message/format argument pair.

To check an argument property:

    def sqrt(num)
      Preconditions.check_argument(num > 0)
      ...
    end

or alternatively
    
    def sqrt(num)
      Preconditions.check_block("sqrt doesn't yet support complex numbers") { num > 0 }
      ...
    end

To check the type of an object being supplied:

    def sqrt(num)
      Preconditions.check_type(num, Integer, 
                               "sqrt is integer only, you supplied a %s", num.class)
      ...
    end

To check if an object will respond to a method you intend to call:

    def sqrt(num)
      Preconditions.check_reponds_to(num, :sqrt,
                                     "yup, we're that lazy")
      ...
    end

If you wish to avoid the `Preconditions` prefix on every call, you can include the `Preconditions` module into your class:

    class SpiffyClass
      include Preconditions
      
      def a(x)
        check_not_null(x)
        ...
      end
      
      def self.b(y)
        check_not_null(y)
        ...
      end
    end

Where possible the `check_` methods will return the object being checked.  In
the cases where this is not possible (`check_argument` and `check_block`) the
boolean result of the expression is returned.

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
