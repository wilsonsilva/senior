# frozen_string_literal: true
require 'tiktoken'
require_relative 'utils'

class GPT
  MODEL = 'gpt-4'
  # MODEL = 'gpt-3.5-turbo'
  TOKEN_BUFFER = 50
  COMBINED_TOKEN_LIMIT = 8192 - TOKEN_BUFFER # gpt-4
  # COMBINED_TOKEN_LIMIT = 4097 - TOKEN_BUFFER # gpt-3
  MAX_RESPONSE_TOKENS = 1000
  MAX_REQUEST_TOKENS = COMBINED_TOKEN_LIMIT - MAX_RESPONSE_TOKENS
  ENCODING = Tiktoken.encoding_for_model(MODEL)
  TOKENS_PER_MESSAGE = 3
  TOKENS_PER_NAME = 1
  USER_INPUT_SUFFIX = 'Determine which next action to use, and write one valid action, a newline, and one valid metadata JSON object, both according to the specified schema:'

  def chat(user_directions, general_directions, message_history, new_plan = nil)
    system_message_content = "#{user_directions}\n#{general_directions}"
    system_message = {'role' => 'system', 'content' => system_message_content}

    user_message_content = USER_INPUT_SUFFIX
    user_message_content = "Change your plan to: #{new_plan}\n#{user_message_content}" unless new_plan.nil?

    user_message = {'role' => 'user', 'content' => user_message_content}
    messages = [system_message, user_message]
    insert_history_at = messages.length - 1
    request_token_count = count_tokens(messages)

    message_history.reverse_each do |message|
      message_token_count = count_tokens([message])
      break if request_token_count + message_token_count > MAX_REQUEST_TOKENS

      request_token_count += message_token_count
      messages.insert(insert_history_at, message)
    end

    available_response_tokens = COMBINED_TOKEN_LIMIT - request_token_count
    # puts("=== MESSAGES START ===")
    # messages.each do |message|
    #   puts("#{message["role"]} #{message["content"][0..99]} #{count_tokens([message])}")
    # end
    # puts("=== MESSAGES END ===")
    # puts("available_response_tokens: #{available_response_tokens}")
    assistant_response = send_message(messages, available_response_tokens, user_directions)
    message_history.push(user_message)
    message_history.push({ 'role' => 'assistant', 'content' => assistant_response })
    assistant_response
  end

  def count_tokens(messages)
    token_count = 0

    messages.each do |message|
      token_count += TOKENS_PER_MESSAGE
      message.each do |key, value|
        token_count += ENCODING.encode(value).length
        token_count += TOKENS_PER_NAME if key == 'name'
      end
    end

    token_count += 3
    token_count
  end

  def send_message(messages, max_response_tokens, user_directions = 'a')
    cassette = Utils.to_snake_case(user_directions)

    # VCR.use_cassette(cassette) do
      # loop do
        message = Senior.brain.chat(model: MODEL, messages: messages, max_tokens: max_response_tokens)
        return message
        # rescue OpenAI::Error::RateLimitError
    rescue StandardError => e
        puts e
        # puts("Model #{MODEL} currently overloaded. Waiting 10 seconds...")
      # end
    end
  # end
end
