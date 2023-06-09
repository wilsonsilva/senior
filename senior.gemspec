# frozen_string_literal: true

require_relative 'lib/senior/version'

Gem::Specification.new do |spec|
  spec.name = 'senior'
  spec.version = Senior::VERSION
  spec.authors = ['Wilson Silva']
  spec.email = ['wilson.dsigns@gmail.com']

  spec.summary = 'An AI-powered pair programmer'
  spec.description = "An AI-powered pair programmer. Provides a user-friendly interface for using AI API's to
    automatically repair broken code and suggest improvements. Simply provide the faulty code as input, and the gem will
    generate a corrected version using advanced machine learning techniques."

  spec.homepage = 'https://github.com/wilsonsilva/senior'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  # Security
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/wilsonsilva/senior'
  spec.metadata['changelog_uri'] = 'https://github.com/wilsonsilva/senior/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'method_source', '~> 1.0'
  spec.add_dependency 'ruby-openai', '~> 3.7'

  spec.add_development_dependency 'bundler-audit', '~> 0.9'
  spec.add_development_dependency 'dotenv', '~> 2.8'
  spec.add_development_dependency 'guard', '~> 2.18'
  spec.add_development_dependency 'guard-bundler', '~> 3.0'
  spec.add_development_dependency 'guard-bundler-audit', '~> 0.1'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'guard-rubocop', '~> 1.5'
  spec.add_development_dependency 'overcommit', '~> 0.60'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rbs', '~> 2.8'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rubocop', '~> 1.49'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6'
  spec.add_development_dependency 'rubocop-rspec', '2.19'
  spec.add_development_dependency 'simplecov', '= 0.17' # the latest versions don't play well with code climate
  spec.add_development_dependency 'simplecov-console', '~> 0.9'
  spec.add_development_dependency 'steep', '~> 1.3'
  spec.add_development_dependency 'typeprof', '~> 0.21'
  spec.add_development_dependency 'vcr', '~> 6.1'
  spec.add_development_dependency 'webmock', '~> 3.18'
  spec.add_development_dependency 'yard', '~> 0.9'
  spec.add_development_dependency 'yard-junk', '~> 0.0.9'
  spec.add_development_dependency 'yardstick', '~> 0.9'
end
