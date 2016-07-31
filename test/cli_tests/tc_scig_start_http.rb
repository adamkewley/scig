require "test/unit"
require "open3"
require_relative "cli-helpers"
require 'socket' # Open TCP sockets

class TestScigStartHttp < Test::Unit::TestCase
  # Should be able to write the help documentation
  def test_show_help_returns_exit_code_0
    assert_equal 0, get_scig_exit_code_with("start http --help")
  end

 # It shouldn't matter if the --help flag comes earlier in the
 # argument list
  def test_show_help_is_successful_even_when_reordered
    assert_equal 0, get_scig_exit_code_with("--help start http")
    assert_equal 0, get_scig_exit_code_with("start --help http")
  end

  def test_show_help_writes_something_to_the_standard_output
    standard_output_text = get_scig_stdout_with "start http --help"

    assert !standard_output_text.empty?
  end

  def test_show_help_does_not_write_anything_to_the_standard_error
    stderr_text = get_scig_stderr_with "start http --help"

    assert stderr_text.empty?
  end

  def test_show_help_contains_usage_statement
    help_text = get_scig_stdout_with "start http --help"

    assert help_text.downcase.include? 'usage'
    assert help_text.include? 'scig start http'
  end

  def test_show_help_contains_list_of_options
    expected_options = ['-p', '--port']

    help_text = get_scig_stdout_with 'start http --help'

    expected_options.each do |option|
      assert help_text.include? option
    end
  end

  # (spec) --port is validated during the initialization of scig. A
  # malformed port will result in an error message being written to
  # the standard error. After writing that error message, the scig
  # process will terminate with an exit code of 1
  def test_provide_invalid_port_value_results_in_error_message
    # TCP port numbers are 2^16 (65536), so any number greater than
    # that should be invalid
    an_invalid_port_identifier = 99999

    scig_arguments = "start http --port #{an_invalid_port_identifier} #{PATH_TO_VALID_DEVICE_SPEC} #{AVAILABLE_SERIAL_DEVICE}"

    outputs = call_scig_with scig_arguments

    # sanity
    assert outputs[:stdout].empty?

    assert !outputs[:stderr].empty?

    assert_not_equal 0, outputs[:exit_code]

    expected_error_message = "scig: #{an_invalid_port_identifier} is not a valid TCP port. The port number must be between 1-65535\n"

    assert_equal expected_error_message, outputs[:stdout]
  end

  def test_provide_port_in_use_results_in_error
    begin
      port = get_available_tcp_port
      expected_error_message = "scig: Cannot open port #{port}: Permission denied."

      # Block open a port
      socket = TCPServer.open('localhost', port)

      return_values =
        call_scig_with("start http --port #{port} #{PATH_TO_VALID_DEVICE_SPEC} #{AVAILABLE_SERIAL_DEVICE}")

      assert 1, return_values[:exit_code]
      assert !return_values[:stderr].empty?
      assert_equal expected_error_message, return_values[:stderr]
    ensure
      socket.close
      assert false
    end
  end

  def test_provide_non_existentient_device_spec_path_results_in_error
    device_spec_path = generate_temporary_file_path
    expected_error_message = "scig: #{device_spec_path}: No such file or directory"
    port = get_available_tcp_port

    return_value =
      call_scig_with("start http --port #{port} #{device_spec_path} #{AVAILABLE_SERIAL_DEVICE}")

    assert_equal 1, return_value[:exit_code]
    assert !return_value[:stderr].empty?
    assert_equal expected_error_message, return_value[:stderr]
  end

  def test_provide_insufficient_permission_to_read__device_spec_results_in_error
    begin
      path = create_temporary_file
      expected_error_message = "scig: #{path}: Permission denied."

      port = get_available_tcp_port

      # 'w' should lock it open
      fd = File.open path, 'w'

      return_value =
        call_scig_with("start http --port #{port} #{path} #{AVAILABLE_SERIAL_DEVICE}")

      assert_equal 1, return_value[:exit_code]
      assert !return_value[:stderr].empty?
      assert_equal expected_error_message, return_value[:stderr]
    ensure
      fd.close
    end
  end

  def test_validation_errors_in_device_spec_results_in_error
    expected_error_message = "$device_spec_file: $parse_error_message"

    # TODO: Create several yaml files that have known validation errors

    assert false
  end

  def test_malformed_device_port_value_results_in_error
    expected_error_message = "scig: The supplied device port ($device_port) is not a valid serial port identifier. $platform_dependant_text"

    # TODO: Create a non-serial device pathname, provide that

    assert false
  end

  def test_non_existient_device_port_value_results_in_error
    expected_error_message = "scig: The supplied serial port ($device_port) does not exist."
    assert false
  end

  def test_cannot_open_port_results_in_error
    expected_error_message = "scig: Cannot open the supplied serial port ($device_port). Access is denied."
    assert false
  end
end
