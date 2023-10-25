#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'dotenv/load'
require 'senior'

require 'tty-spinner'
require 'tty-prompt'
require_relative 'actions'
require_relative 'response_parser'
require_relative 'action_runner'
require_relative 'speech'
require_relative 'gpt'

Senior.configure do |config|
  config.open_ai.access_token = ENV.fetch('OPEN_AI_ACCESS_TOKEN')
  config.open_ai.organization_id = ENV.fetch('OPEN_AI_ORGANIZATION_ID') # Optional
end

# require 'vcr'
# require 'webmock'
#
# VCR.configure do |config|
#   config.cassette_library_dir = 'bin/cassettes'
#   config.hook_into :webmock
#
#   # config.filter_sensitive_data('<OPEN_AI_ACCESS_TOKEN>') { Senior.configuration.open_ai.access_token }
#   # config.filter_sensitive_data('<OPEN_AI_ORGANIZATION_ID>') { Senior.configuration.open_ai.organization_id }
#
#   config.filter_sensitive_data('<OPEN_AI_ACCESS_TOKEN>') do |interaction|
#     auths = interaction.request.headers['Authorization']&.first
#
#     if auths && (match = auths.match(/^Bearer\s+([^,\s]+)/))
#       match.captures.first
#     end
#   end
#
#   config.filter_sensitive_data('<OPEN_AI_ORGANIZATION_ID>') do |interaction|
#     interaction.request.headers['Openai-Organization']&.first
#   end
#
#   config.filter_sensitive_data('<OPEN_AI_ORGANIZATION_ID>') do |interaction|
#     interaction.response.headers['Openai-Organization']&.first
#   end
#
#   config.filter_sensitive_data('<ELEVENLABS_API_KEY>') do |interaction|
#     interaction.request.headers['Xi-Api-Key']&.first
#   end
# end
#
# WebMock.disable_net_connect!(allow_localhost: true)

message_history = []

general_directions = <<~DIRECTIONS
  Your decisions must always be made independently without seeking user assistance. Play to your strengths as an LLM and
  pursue simple strategies with no legal complications.


  CONSTRAINTS:
  1. No user assistance.
  2. Cannot run Ruby code that requires user input.


  ACTIONS:

  1. "READ_FILE": read the current state of a file. The schema for the action is:

  READ_FILE: <PATH>

  2. "WRITE_FILE": write a block of text to a file. The schema for the action is:

  WRITE_FILE: <PATH>
  ```
  <TEXT>
  ```

  3. "RUN_RUBY": run a Ruby file. The schema for the action is:

  RUN_RUBY: <PATH>

  4. "SEARCH_ONLINE": search online and get back a list of URLs relevant to the query. The schema for the action is:

  SEARCH_ONLINE: <QUERY>

  5. EXTRACT_INFO: extract specific information from a webpage. The schema for the action is:

  EXTRACT_INFO: <URL>, <a brief instruction to GPT for information to extract>

  6. "SHUTDOWN": shut down the program. The schema for the action is:

  SHUTDOWN


  RESOURCES:
  1. File contents after reading file.
  2. Online search results returning URLs.
  3. Output of running a Ruby file.


  PERFORMANCE EVALUATION:
  1. Continuously review and analyze your actions to ensure you are performing to the best of your abilities.
  2. Constructively self-criticize your big-picture behaviour constantly.
  3. Reflect on past decisions and strategies to refine your approach.
  4. Every action has a cost, so be smart and efficient. Aim to complete tasks in the least number of steps.


  Write only one action. The action must one of the actions specified above and must be written according to the schema
  specified above.

  After the action, also write the following metadata JSON object, which must be parsable by Ruby's JSON.parse()
  {
      "criticism": "<constructive self-criticism of actions performed so far, if any>",
      "reason": "<a sentence explaining the action above>",
      "plan": "<a short high-level plan in plain English>",
      "speak": "<a short summary of thoughts to say to the user>"
  }

  If you want to run an action that is not in the above list of actions, send the SHUTDOWN action instead and explain
  which action you wanted to run in the metadata JSON object.

  So, write one action and one metadata JSON object, nothing else.
DIRECTIONS

prompt = TTY::Prompt.new
user_directions = prompt.ask('What would you like me to do:')
# user_directions = 'Who is the current CEO of Twitter?'
# user_directions = 'write a hello world script in ruby'

FileUtils.mkdir_p('bin/workspace')
Dir.chdir('bin/workspace')

new_plan = nil
gpt = GPT.new
speech = Speech.new
pastel = Pastel.new
spinner = TTY::Spinner.new('[:spinner] Thinking...', format: :dots_2)
action_runner = ActionRunner.new(pastel, gpt)

loop do
  puts('========================')
  spinner.spin
  puts user_directions

  assistant_response = gpt.chat(user_directions, general_directions, message_history, new_plan)
  spinner.stop
  action, metadata = ResponseParser.parse(assistant_response)

  puts("#{pastel.green("ACTION: ")}#{action.short_string}")
  speech.say_async(metadata.speak) unless action.is_a?(ShutdownAction)
  # speech.say_async('Your feedback is appreciated. Now pay 8$') unless action.is_a?(ShutdownAction)

  if action.is_a?(ShutdownAction)
    puts pastel.red('Shutting down...')
    break
  else
    puts("#{pastel.green("REASON: ")}#{metadata.reason}")
    puts("#{pastel.green("PLAN: ")}#{metadata.plan}")
    puts("#{pastel.green("SELF-CRITICISM: ")}#{metadata.criticism}") unless metadata.criticism.strip.empty?
  end
  run_action = prompt.yes?('Run the action?')
  break unless run_action

  action_output = action_runner.run(action)
  message_content = "Action #{action.key} returned:\n#{action_output}"
  message_history.append({ role: 'system', content: message_content })
  keep_plan = prompt.no?('Change the proposed plan?')

  if keep_plan
    new_plan = nil
  else
    new_plan = prompt.ask('What would you like me to change the plan to?')
  end
end
