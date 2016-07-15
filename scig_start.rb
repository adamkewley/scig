require 'optparse'
require_relative 'sub_command'
require_relative 'scig_start_http'

def scig_start(argv)
  # Options for "scig start" context
  options = {
    show_help: false,
    unknown_options_provided: false
  }

  $supported_processes = [
    SubCommand.new(
      'http',
      'Start a http server that controls the specified device',
      lambda { |args| scig_start_http(args) })
  ]

  start_options = argv.dup

  option_parser = OptionParser.new do |opts|
    opts.banner = "Usage: scig start [options]"

    opts.on("-h", "--help") do
      options[:show_help] = true
    end
  end

  begin
    option_parser.parse! start_options
  rescue OptionParser::InvalidOption
    options[:unknown_options_provided] = true
  end

  # .parse! mutated the array, remainder is unnamed args
  unnamed_arguments = start_options

  def resolve_current_context(options, option_parser)
    if options[:unknown_options_provided]
      # TODO: "unknown option: $opt_name"
      STDERR.puts option_parser.banner
      exit 1
    elsif options[:show_help]
      usage_and_options = option_parser.help

      commands = $supported_processes.map(&:to_help_text).join("\n")

      puts usage_and_options
      puts "Commands: "
      puts commands

      exit 0
    else
      # Insufficient arguments
      STDERR.puts option_parser.banner
      exit 1
    end
  end

  def start_scig_process(unnamed_arguments, argv)
    process_name = unnamed_arguments.first

    is_a_supported_process =
      $supported_processes.map(&:identifier).include? process_name

    if is_a_supported_process
      process_to_jump_to =
        $supported_processes.
        select { |proc| proc.identifier == process_name }.
        first

      # Remove the $process_identifier argument because, effectively,
      # the start context has "dealt" with it
      arguments_to_pass_to_process =
        argv.select { |arg| arg != process_to_jump_to.identifier }

      # Jump into the process
      process_to_jump_to.entry_method.call arguments_to_pass_to_process
    else
      STDERR.puts "scig start: #{process_name} is not a scig command. See 'scig start --help'."
      exit 1
    end
  end

  if unnamed_arguments.length == 0
    resolve_current_context(options, option_parser)
  else
    start_scig_process(unnamed_arguments, argv)
  end
end
