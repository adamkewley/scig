#!/usr/bin/env ruby

require 'sinatra'

DeviceCommand = Struct.new(:identifier, :handler)

device_commands = [
  DeviceCommand.new('/get-name', lambda { |params| return 'Hello' })
]

device_commands.each do |command|
  get command[:identifier] do
    command[:handler].call(params)
  end
end

not_found do
  "Device command not found"
end
