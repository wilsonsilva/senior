# Senior

[![Gem Version](https://badge.fury.io/rb/senior.svg)](https://badge.fury.io/rb/senior)
[![Tests](https://github.com/wilsonsilva/senior/actions/workflows/main.yml/badge.svg)](https://github.com/wilsonsilva/senior/actions/workflows/main.yml)

Provides AI-powered debugging and automatic suggestion of code fixes. It makes use of OpenAI's language model to analyze
and modify the source code of broken methods, allowing them to be fixed automatically.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add senior

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install senior

## Usage

Before using Senior, ensure that the environment variables `OPEN_AI_ACCESS_TOKEN` and `OPEN_AI_ORGANIZATION_ID` are
defined. These variables are used by the gem to authenticate and access OpenAI's language model.

### Auto-debugging a broken method
To debug a broken method, call Senior.auto_debug and pass in the broken method, its arguments, and optionally its
source code. The method will be called repeatedly, with modifications made to its source code each time, until it no
longer raises exceptions.

```ruby
def square(n) = n * y

result = Senior.auto_debug(method(:square), 2)
puts result # => 4
```

### Suggesting a fix for a broken method
To suggest a fix for a broken method, call Senior.suggest_fix and pass in the broken method and its arguments.
The method will be analyzed and a fix will be suggested in the form of modified source code.

```ruby
def square(n) = n * y

suggestion = Senior.suggest_fix(method(:square), 2)
puts suggestion # => "def square(n) = n * n"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.

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
