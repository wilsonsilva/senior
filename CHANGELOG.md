## [Unreleased]

- Ability to wrap a method invocation. For example, `Senior.suggest_fix { my_broken_method(2) }`
- Test generation `Senior.write_tests_for {}`
- Ability to criticize code
- Identify code smells
- Suggest refactorings
- Optimise the code
- Document the code
- Generate diagrams
- Web interface
- IntelliJ plugin
- VSCode plugin
- See price per call
- Set API calling and pricing limits
- Use different AI APIs, not just OpenAI
- Global convenience methods such as `auto_debug { }`
- Guard plugin
- RBS Signatures
- Domain exceptions

## [0.3.0] - 2023-04-11

### Added
- Added support for OpenAI's Chat Completion API. Setting `Senior.configuration.open_ai.model`
to any value of `Senior::Brains::OpenAI::CHAT_MODELS` will cause API requests to be sent to `/chat/completions`.
Whereas setting `Senior.configuration.open_ai.model` to any value of `Senior::Brains::OpenAI::COMPLETION_MODELS`
will cause API requests to be sent to `/completions`.

### Changed
- Updated the gem's summary and description to match the idea of the gem - A senior software engineer assistant.
- Updated the `bin/setup` script to copy the `.env.example` file to `.env`

## [0.2.0] - 2023-04-10

### Added
- Added the ability to configure the gem with a block:
```ruby
Senior.configure do |config|
  config.open_ai.access_token = ENV.fetch('OPEN_AI_ACCESS_TOKEN')
  config.open_ai.organization_id = ENV.fetch('OPEN_AI_ORGANIZATION_ID') # Optional
  config.open_ai.api_version = 'v1'
  config.open_ai.max_tokens = 1024
  config.open_ai.model = 'text-davinci-003'
  config.open_ai.n = 1
  config.open_ai.request_timeout = 120
  config.open_ai.temperature = 0.7
  config.open_ai.uri_base = 'https://api.openai.com/'
end
```
These configurations are used as default values for the OpenAI API calls.

## [0.1.0] - 2023-04-10

- Initial release

[0.3.0]: https://github.com/wilsonsilva/senior/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/wilsonsilva/senior/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/wilsonsilva/senior/compare/eecec20...v0.1.0
