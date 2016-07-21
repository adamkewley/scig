require "test/unit"
require "open3"
require_relative "cli-helpers"

class TestScig < Test::Unit::TestCase

  # Should be able to write the help documentation
  def test_show_help_is_successful
    `#{SCIG_CLI} --help`

    assert $?.success?
  end

  # (spec) The help documentation will be written to the standard output
  def test_show_help_writes_something_to_standard_output
    returned_text = `#{SCIG_CLI} --help`

    assert !returned_text.empty?
  end

  # It shouldn't write anything to the standard error
  def test_show_help_does_not_write_anything_to_the_standard_error
    Open3.popen3("#{SCIG_CLI} --help") do |stdin, stdout, stderr, wait|
      assert stderr.read.empty?
    end
  end

  # (spec) Contains a general header explai

  # (spec) Contains a usage statement
  def test_show_help_contains_usage_statement
    help_text = `#{SCIG_CLI} --help`

    help_text.downcase!

    assert help_text.include? 'usage'
    assert help_text.include? 'scig'
  end

  # (spec) Contains a list of arguments for the base context
  def test_show_help_contains_list_of_arguments_for_the_base_context
    base_context_arguments = ['-h', '--help']

    help_text = `#{SCIG_CLI} --help`

    base_context_arguments.each do |argument|
      assert help_text.include? argument
    end
  end

  # (spec) Contains a list of commands and their purpose
  # TODO: make more robust
  def test_show_help_contains_list_of_commands_from_base_context
    base_context_commands = ['start']

    help_text = `#{SCIG_CLI} --help`

    base_context_commands.each do |command|
      assert help_text.include? command
    end
  end

  # After the help text has been written to the standard output, the scig
  # process will terminate with an exit code of 0 (no error)
  def test_show_help_returns_exit_code_0
    `#{SCIG_CLI} --help`

    exit_code = $?.exitstatus

    assert_equal 0, exit_code
  end

  # If an unknown command is provided, it should echo an error into the standard
  # error
  def test_provide_invalid_argument_echoes_error_message_to_stdout
    Open3.popen3("#{SCIG_CLI} obviously_not_a_supported_command") do |stdin, stdout, stderr, wait|
      has_error_text = !stderr.read.empty?
      assert has_error_text
    end
  end

  # (spec) If an unnamed argument is provided but it is not a known command
  # identifier, scig shall write the following message to the standard error:
  # "scig: '$first_argument' is not a scig command. See 'scig --help'.
  def test_provide_invalid_unnamed_argument_echoes_correct_message_to_stdout
    invalid_unnamed_arg = "obviously_not_a_supported_command"

    expected_error_message = "scig: '#{invalid_unnamed_arg}' is not a scig command. See 'scig --help'.\n"

    Open3.popen3("#{SCIG_CLI} #{invalid_unnamed_arg}") do |stdin, stdout, stderr, wait|
      actual_error_message = stderr.read

      assert_equal expected_error_message, actual_error_message
    end
  end

  # (spec) After printing the error message, the scig process shall exit with a
  # return code of 1 (general error)
  def test_provide_invalid_argument_returns_exit_code_1
    `#{SCIG_CLI} obviously_not_a_supported_command`

    exit_code = $?.exitstatus

    assert_equal 1, exit_code
  end

  def test_provide_invalid_argument_echoes_nothing_to_stdout
    stdout_text = `#{SCIG_CLI} obviously_not_a_supported_command`

    assert stdout_text.empty?
  end

  # (spec) If insufficient arguments are supplied to a scig call then the scig
  # process will write the help documentation to the standard error...
  def test_provide_insufficient_arguments_produces_usage_instructions_in_stderr
    Open3.popen3("#{SCIG_CLI}") do |stdin, stdout, stderr, wait|
      error_message = stderr.read

      assert !error_message.empty?

      # TODO: make this more robust
      assert error_message.downcase.include? 'usage'
    end
  end

  # ...followed by terminating with an exit code of 1 (general error)
  def test_provide_insufficient_arguments_terminates_with_exit_code_1
    `#{SCIG_CLI}`

    exit_code = $?.exitstatus

    assert_equal 1, exit_code
  end

  # Providing insufficient argument should write nothing to the standard output
  def test_provide_insufficient_arguments_writes_nothing_to_standard_output
    returned_text = `#{SCIG_CLI}`

    assert returned_text.empty?
  end
end
