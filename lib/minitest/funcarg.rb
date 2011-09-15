# We have some intense restrictions at the moment to minimize
# development time for this proof of concept. This restriction
# is due to the method we use to reflect the argument names.
if RUBY_ENGINE != "ruby" || RUBY_VERSION != "1.9.2"
  raise "Sorry, you can only run minitest-funcarg on Ruby 1.9.2 at the moment."
end

require "minitest/unit"

# This is the only file that needs to be included when enabling
# minitest-funcarg.
module MiniTest
  module Funcarg
    def self.included(cls)
      cls.extend(ClassMethods)
    end

    module ClassMethods
      # This is a magic lifecycle hook that the Ruby VM calls when
      # a method is added to the class.
      def method_added(name)
        # Ignore non test methods
        return if name !~ /^test_/

        # These are the new method names.
        no_funcarg_method = "_nofuncarg_#{name}"
        funcarg_method = "_funcargs_#{name}"

        # Ignore methods where we already have the funcarg method
        begin
          instance_method(funcarg_method)

          # If we get to this point it means we have the method
          return
        rescue NameError
          # Do nothing, we're going to create it.
        end

        # Get a list of the parameter names
        params = instance_method(name).parameters.map do |type, name|
          raise "Funcargs only support required parameters." if type != :req
          name
        end

        # Define the new test method that loads the funcargs and calls
        # a redefined test method that takes no parameters.
        define_method(funcarg_method) do
          args = params.map { |p| self.send("minitest_funcarg__#{p}") }
          self.send(no_funcarg_method, *args)
        end

        # Alias out the test method
        alias_method no_funcarg_method, name
        alias_method name, funcarg_method
      end
    end
  end
end

# Force MiniTest TestCase to include the funcarg framework.
MiniTest::Unit::TestCase.send(:include, MiniTest::Funcarg)
