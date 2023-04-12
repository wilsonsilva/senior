# Senior

[![Gem Version](https://badge.fury.io/rb/senior.svg)](https://badge.fury.io/rb/senior)
[![Tests](https://github.com/wilsonsilva/senior/actions/workflows/main.yml/badge.svg)](https://github.com/wilsonsilva/senior/actions/workflows/main.yml)
[![Test Coverage](https://api.codeclimate.com/v1/badges/87e6e2167d3283e3b79b/test_coverage)](https://codeclimate.com/github/wilsonsilva/senior/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/87e6e2167d3283e3b79b/maintainability)](https://codeclimate.com/github/wilsonsilva/senior/maintainability)

An AI-powered pair programmer. Provides a user-friendly interface for using AI API's to automatically repair broken code
and suggest improvements. Simply provide the faulty code as input, and the gem will generate a corrected version using
advanced machine learning techniques.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Auto-debugging a broken method](#auto-debugging-a-broken-method)
  - [Suggesting a fix for a broken method](#suggesting-a-fix-for-a-broken-method)
- [Development](#development)
  - [Type checking](#type-checking)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add senior

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install senior

## Usage

- Get your API key from https://platform.openai.com/account/api-keys
- (optional) If you belong to multiple organizations, you can get your Organization ID from https://platform.openai.com/account/org-settings
- Configure the library by passing your OpenAI API credentials:

```ruby
Senior.configure do |config|
  config.open_ai.access_token = ENV.fetch('OPEN_AI_ACCESS_TOKEN')
  config.open_ai.organization_id = ENV.fetch('OPEN_AI_ORGANIZATION_ID') # Optional
end
```

Note that `OPEN_AI_ACCESS_TOKEN` and `OPEN_AI_ORGANIZATION_ID` are environment variables that should be set in your
environment. You should never hardcode your API credentials directly in your code, as this is a security risk.
Instead, store your API credentials securely, such as using environment variables or a separate configuration file that
is excluded from source control.

Once you have configured the gem, you can use the `Senior` module to interact with the OpenAI API.

### Auto-debugging a broken method
To debug a broken method, call `Senior.auto_debug_method` and pass in the broken method and its arguments. The method will be
called repeatedly, with modifications made to its source code each time, until it no longer raises exceptions.

```ruby
def square(n) = n * y

result = Senior.auto_debug_method(method(:square), 2)
puts result # => 4
```

### Suggesting a fix for a broken method
To suggest a fix for a broken method, call `Senior.suggest_method_fix` and pass in the broken method and its arguments.
The method will be analyzed and a fix will be suggested in the form of modified source code.

```ruby
def square(n) = n * y

suggestion = Senior.suggest_method_fix(method(:square), 2)
puts suggestion # => "def square(n) = n * n"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.

Set your OpenAI API credentials in the environment variables `OPEN_AI_ACCESS_TOKEN` and `OPEN_AI_ORGANIZATION_ID`.
Either in your machine's environment or in a `.env` file in the root of the project.

To install this gem onto your local machine, run `bundle exec rake install`.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`,
which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file
to [rubygems.org](https://rubygems.org).

The health and maintainability of the codebase is ensured through a set of
Rake tasks to test, lint and audit the gem for security vulnerabilities and documentation:

```
rake build                    # Build senior.gem into the pkg directory
rake build:checksum           # Generate SHA512 checksum if senior.gem into the checksums directory
rake bundle:audit:check       # Checks the Gemfile.lock for insecure dependencies
rake bundle:audit:update      # Updates the bundler-audit vulnerability database
rake clean                    # Remove any temporary products
rake clobber                  # Remove any generated files
rake coverage                 # Run spec with coverage
rake install                  # Build and install senior.gem into system gems
rake install:local            # Build and install senior.gem into system gems without network access
rake qa                       # Test, lint and perform security and documentation audits
rake release[remote]          # Create a tag, build and push senior.gem to rubygems.org
rake rubocop                  # Run RuboCop
rake rubocop:autocorrect      # Autocorrect RuboCop offenses (only when it's safe)
rake rubocop:autocorrect_all  # Autocorrect RuboCop offenses (safe and unsafe)
rake spec                     # Run RSpec code examples
rake verify_measurements      # Verify that yardstick coverage is at least 100%
rake yard                     # Generate YARD Documentation
rake yard:junk                # Check the junk in your YARD Documentation
rake yardstick_measure        # Measure docs in lib/**/*.rb with yardstick
```

### Type checking

This gem leverages [RBS](https://github.com/ruby/rbs), a language to describe the structure of Ruby programs. It is
used to provide type checking and autocompletion in your editor. Run `bundle exec typeprof FILENAME` to generate
an RBS definition for the given Ruby file. And validate all definitions using [Steep](https://github.com/soutaro/steep)
with the command `bundle exec steep check`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wilsonsilva/senior. This project is intended
to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the
[code of conduct](https://github.com/wilsonsilva/senior/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Senior project's codebases, issue trackers, chat rooms and mailing lists is expected to
follow the [code of conduct](https://github.com/wilsonsilva/senior/blob/main/CODE_OF_CONDUCT.md).
