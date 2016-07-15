# Basic struct that represents the information related to a CLI
# subcommand (e.g. "start", as a subcommand to "scig").
class SubCommand
  # The identifier of the subcommand.
  # Examples: <tt>start</tt>, <tt>http</tt>
  attr_accessor :identifier

  # A human-readable description of what the subcommand does.
  # Example: "Start a http server that controls the specified device"
  attr_accessor :description

  # A lambda that executes the subcommand. The lambda should recieve
  # the CLI's argument list (in effect, ARGV).
  attr_accessor :entry_method

  # Create an instance of a SubCommand: a representation of a scig CLI
  # context-changing subcommang (e.g. "start", "http")
  def initialize(identifier, description, entry_method)
    self.identifier = identifier
    self.description = description
    self.entry_method = entry_method
  end

  # Create a text representation of a SubCommand that is suitable to
  # display as part of a CLI's --help text
  #
  # Example:
  #  http_command.to_help_text # => "http	Start a http server that controls the device"
  def to_help_text
    "#{self.identifier}	#{self.description}"
  end
end
