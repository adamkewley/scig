#!/usr/bin/env ruby

# The application takes two arguments: "echo" and "return code" It will echo the
# "echo" message, followed by a newline, and then return "return code" as the
# application's return code

number_of_arguments = ARGV.length

if (number_of_arguments != 2)
  STDERR.puts("Usage: ruby #{__FILE__} echo return_code")
  exit 1
end

echo_string = ARGV[0]
return_code = ARGV[1].to_i

puts echo_string

exit return_code
