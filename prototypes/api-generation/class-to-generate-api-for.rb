# This class represents an arbitrary class for the sake of showing how
# rdoc works {good examples}[http://edgeguides.rubyonrails.org/api_documentation_guidelines.html]
class MyClass

  # Does nothing
  def foo
  end

  # Concatenates +arg1+ and +arg2+.
  #
  # ==== Parameters
  # * +arg1+ - +String+ object that appears at the start of the return value.
  # * +arg2+ - +String+ object that appears at the end of the return value.
  #
  # ==== Examples
  #  my_class.bar("He", "llo") # => "Hello"
  #  my_class.bar("12", "34")  # => "1234"
  def bar(arg1, arg2)
  end
end
