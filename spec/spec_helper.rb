# frozen_string_literal: true

require 'simplecov'
require 'simplecov-console'

SimpleCov.formatter = SimpleCov::Formatter::Console unless ENV['COVERAGE_FORMAT'] == 'html'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console
  ]
)

require 'senior'
require 'dotenv/load'
require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around do |example|
    VCR.use_cassette(example.metadata[:full_description]) do
      example.run
    end
  end
end
