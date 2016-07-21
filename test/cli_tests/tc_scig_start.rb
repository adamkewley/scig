require "test/unit"
require "open3"
require_relative "cli-helpers"

class TestScigStart < Test::Unit::TestCase
  # Should be able to see the "scig start" help documentation.
  def test_show_scig_start_help_is_successful
    `#{SCIG_CLI} start --help`

    assert $?.success?
  end

  # (spec) The help documentation will be written to the standard output.
  def test_show_scig_start_help_writes_something_to_standard_output
    echoed_text = `#{SCIG_CLI} start --help`

    assert !echoed_text.empty?
  end

  # It shouldn't write anything to the standard error.
  def test_show_scig_start_help_writes_nothing_to_standard_error
    Open3.popen3("#{SCIG_CLI} start --help") do |stdin, stdout, stderr, wait|
      assert stderr.read.empty?
    end
  end

  # (spec) Contains a usage statement.
  def test_show_scig_start_help_contains_usage_statement
    help_text = `#{SCIG_CLI} start --help`

    # TODO: make more robust
    assert help_text.downcase.include? 'usage'
  end

  # (spec) Contains a list of arguments for the "start" context
  def test_show_scig_start_help_contains_list_of_arguments_for_start_context
    start_context_arguments = ['-h', '--help']

    help_text = `#{SCIG_CLI} start --help`

    start_context_arguments.each do |argument|
      help_text.include? argument
    end
  end

  # (spec) Contains a list of commands for the start context
  def test_show_scig_start_help_contains_list_of_commands_for_start_context
    start_context_commands = ['http']

    help_text = `#{SCIG_CLI} start --help`

    start_context_commands.each do |command|
      # TODO: make this more robust
      help_text.include? command
    end
  end

  # (spec) After the documentation has been written to the standard
  # output, the scig process will terminate with an exit code of 0
  def test_show_scig_start_help_has_exit_code_0
    `#{SCIG_CLI} start --help`

    exit_code = $?.exitstatus

    assert_equal 0, exit_code
  end
end
