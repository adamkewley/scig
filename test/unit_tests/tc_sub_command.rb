require_relative "../../sub_command"

class TestSubCommand < Test::Unit::TestCase

  def test_sub_command_ctor_does_not_throw_with_valid_arguments
    SubCommand.new('identifier', 'desc', lambda { |arg1| })
  end

end
