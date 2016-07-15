#!/usr/bin/env ruby

require 'test/unit'

APP_CALL = "bundle exec ruby cli-application.rb"

class TestCliApplication < Test::Unit::TestCase

  def test_run_app_with_no_args_generates_error
    output = `#{APP_CALL}`

    assert_not_nil(output)

    return_code = $?.exitstatus

    assert_equal(1, return_code)
  end

  def test_run_app_with_correct_args_returns_return_number
    return_number = 0

    output = `#{APP_CALL} "echo_this" #{return_number}`

    assert_not_nil(output)

    return_code = $?.exitstatus

    assert_equal(return_number, return_code)
  end

  def test_run_app_with_correct_args_returns_echo_string
    echo_string = "echo this"

    output = `#{APP_CALL} "#{echo_string}" 0`

    assert_not_nil(output)

    # Sanity
    assert_equal(0, $?.exitstatus)

    assert_equal(echo_string + "\n", output)
  end
end
