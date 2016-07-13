#!/usr/bin/env ruby

require 'serialport'

if(ARGV.length == 0)
  STDERR.puts "Usage: ruby #{__FILE__} serial_port_device"
  exit 1
end

port_identifier = "/dev/ttyS98"

if(not File.exist? port_identifier)
  STDERR.puts "Error: #{port_identifier} does not exist"
  exit 1
end

port_parameters = {
  "baud" => 9600,
  "data_bits" => 8,
  "stop_bits" => 1,
  "parity" => SerialPort::NONE
}

port_handle =
  SerialPort.new(
                 port_identifier,
                 port_parameters)

port_handle.puts("hello")
