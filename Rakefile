desc "Generate fully processed README.md from preprocessed format"
task :generate_readme do |t|
  ruby 'tools/preprocess-markdown -o README.md docs/README.md'
end

desc "Run all (cli & unit) tests"
task :test do
  ruby "test/test_helper.rb"
end
