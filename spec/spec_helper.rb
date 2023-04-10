# frozen_string_literal: true

require 'simplecov'
require 'simplecov-console'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console
  ]
)

unless ENV['COVERAGE'] == 'false'
  SimpleCov.start do
    root 'lib'
    coverage_dir "#{Dir.pwd}/coverage"
  end
end

require 'senior'
require 'dotenv/load'
require 'vcr'
require 'webmock/rspec'

Dir[File.expand_path('support/**/*.rb', __dir__)].each { |f| require f }

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock

  config.filter_sensitive_data('<BEARER_TOKEN>') do |interaction|
    auths = interaction.request.headers['Authorization'].first
    if (match = auths.match(/^Bearer\s+([^,\s]+)/))
      match.captures.first
    end
  end

  config.filter_sensitive_data('<ORGANIZATION_ID>') do |interaction|
    interaction.request.headers['Openai-Organization'].first
  end

  config.filter_sensitive_data('<ORGANIZATION_ID>') do |interaction|
    interaction.response.headers['Openai-Organization'].first
  end
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
