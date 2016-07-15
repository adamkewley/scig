#!/usr/bin/env ruby

require 'sinatra/base'

class ScigHttpServer

  def initialize(device_commands)
    @server = Sinatra.new do
      set :port, 12345

      # Register the commands as http entry
      # points
      device_commands.each do |command|
        get command[:identifier] do
          command[:handler].call(params)
        end
      end
    end
  end

  def start
    @server.run!
  end
end

DeviceCommand = Struct.new(:identifier, :handler)

device_commands = [
  DeviceCommand.new('/get-name', lambda { |params| return 'Hello' })
]

http_server = ScigHttpServer.new(device_commands)

http_server.start
