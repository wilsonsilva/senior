# frozen_string_literal: true

require_relative "lib/senior/version"

Gem::Specification.new do |spec|
  spec.name = "senior"
  spec.version = Senior::VERSION
  spec.authors = ["Wilson Silva"]
  spec.email = ["wilson.dsigns@gmail.com"]

  spec.summary = "AI coding companion"
  spec.description = "This gem provides a simple interface to OpenAI's GPT4 API for code repair. Given a piece of broken code, the gem generates a corrected version."
  spec.homepage = "https://github.com/wilsonsilva/senior"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/wilsonsilva/senior"
  spec.metadata["changelog_uri"] = "https://github.com/wilsonsilva/senior/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "rubocop", "~> 1.49"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
