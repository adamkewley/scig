require_relative 'class-to-test'
require 'test/unit'

class TestClassToTest < Test::Unit::TestCase

  def test_addition
    assert_equal(4, ClassToTest.new(2).add(2))
  end

end
