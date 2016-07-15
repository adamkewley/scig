# Load CLI test files
cli_test_files_dirname =
  File.expand_path('../cli_tests', __FILE__)

cli_test_files =
  Dir.glob(cli_test_files_dirname + '/*.rb')

cli_test_files.each do |cli_test_file|
  require_relative cli_test_file
end

# Load unit test files
cli_test_files_dirname =
  File.expand_path('../unit_tests', __FILE__)

cli_test_files =
  Dir.glob(cli_test_files_dirname + '/*.rb')

cli_test_files.each do |cli_test_file|
  require_relative cli_test_file
end
