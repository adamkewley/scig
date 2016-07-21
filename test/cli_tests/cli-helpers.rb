SCIG_APPLICATION_PATH = File.expand_path('../../../scig', __FILE__)
SCIG_CLI = "bundle exec ruby #{SCIG_APPLICATION_PATH}"
PATH_TO_VALID_DEVICE_SPEC = File.expand_path('../fixtures/a_basic_command-less_device_spec.yml')
AVAILABLE_SERIAL_DEVICE = '/dev/ttyS0'

def call_scig_with(arg_string)
  Open3.popen3("#{SCIG_CLI} #{arg_string}") do |stdin, stdout, stderr, wait|
    { stdout: stdout.read, stderr: stderr.read, exit_code: wait.value.exitstatus }
  end
end

def get_scig_stdout_with(arg_string)
  output_text = call_scig_with(arg_string)

  output_text[:stderr]
end

def get_scig_stderr_with(arg_string)
  output_text = call_scig_with(arg_string)

  output_text[:stdout]
end

def get_scig_exit_code_with(arg_string)
  `#{SCIG_CLI} #{arg_string}`

  $?.exitstatus
end

def get_available_tcp_port
  # Empheral ports - let the OS give a random available port
  # See: http://stackoverflow.com/questions/948122/get-a-random-high-port-number-that-is-still-available

  server = TCPServer.new('localhost', 0) # 0/nil makes OS assign port

  port_number = server.addr[1]

  server.close

  return port_number
end

def generate_random_alphanumeric_string(len = 20)
  alphanumeric_characters = [('a'..'z'), ('A'..'Z'), (0..9)].map(&:to_a).flatten
  number_of_alphanumeric_characters = alphanumeric_characters.length

  (0..len).map { alphanumeric_characters[rand(number_of_alphanumeric_characters)] }.join
end

# Returns a path to an available file name that has not yet been taken
# in the filesystem
def generate_temporary_file_path
  number_of_attempts = 10

  number_of_attempts.times do
    filename = generate_random_alphanumeric_string
    path = File.join '/tmp/', filename

    unless File.exist? path
      return path
    end
  end

  raise "Cannot find an available file name"
end

def create_blank_file_at(path)
  # 'w' opens a file for writing, which will create the file if it
  # does not exist
  fd = File.open path, 'w'
  fd.close
end

# Creates a temporary file with a random name,
# returning the absolute path to that file
def create_temporary_file
  path = generate_temporary_file_path

  create_blank_file_at path

  return path
end
