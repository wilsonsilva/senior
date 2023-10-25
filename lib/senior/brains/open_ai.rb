# frozen_string_literal: true

require 'openai'

module Senior
  # Interface with the different AI API's
  module Brains
    # Interface to OpenAI's API
    #
    # @api private
    #
    class OpenAI
      CHAT_MODELS = %w[gpt-4 gpt-4-0314 gpt-4-32k gpt-4-32k-0314 gpt-3.5-turbo gpt-3.5-turbo-0301].freeze
      COMPLETION_MODELS = %w[text-davinci-003 text-davinci-002 text-curie-001 text-babbage-001 text-ada-001
                             davinci curie babbage ada].freeze
      CHAT_SYSTEM_PROMPT = "You're a Ruby dev. Only reply with plain code, no explanations."

      # Suggests a fix for a broken method
      #
      # @api private
      #
      # @param erroneous_source [String] Source code of a broken method
      # @param exception_backtrace [String] First line of a broken method's backtrace
      #
      # @return [String] The suggested fix
      #
      def suggest_method_fix(erroneous_source:, exception_backtrace:)
        prompt = <<~PROMPT
          This is a method's source and the error. Fix the method:

          ## Source:
          #{erroneous_source}

          ## Error:
          #{exception_backtrace}

          ## Updated source:
        PROMPT

        if CHAT_MODELS.include?(defaults.model)
          request_chat_completion(prompt)
        elsif COMPLETION_MODELS.include?(defaults.model)
          request_completion(prompt)
        else
          raise "Unknown model '#{defaults.model}'. If this is a mistake, open a PR in github.com/wilsonsilva/senior"
        end
      end

      # Creates a chat completion in OpenAI's API
      #
      # @api private
      #
      # @param prompt [String] The prompt for which to generate a chat completion TODO: parameters
      #
      # @return [String] The created chat completion
      #
      def chat(parameters = {})
        response = open_ai_client.chat(parameters: parameters)

        raise 'No chat completion found' unless response['choices'].any?

        response.dig('choices', 0, 'message', 'content').strip
      end

      private

      # Creates an instance of OpenAI::Client
      #
      # @api private
      #
      # @return [OpenAI::Client] A client to communicate with OpenAI's API
      #
      def open_ai_client
        @open_ai_client ||= ::OpenAI::Client.new(
          access_token: Senior.configuration.open_ai.access_token,
          organization_id: Senior.configuration.open_ai.organization_id
        )
      end

      # Creates a completion in OpenAI's API
      #
      # @api private
      #
      # @param prompt [String] The prompt for which to generate a completion
      #
      # @return [String] The created completion
      #
      def request_completion(prompt)
        response = open_ai_client.completions(
          parameters: {
            model: defaults.model,
            prompt:,
            max_tokens: defaults.max_tokens,
            n: defaults.n,
            stop: nil,
            temperature: defaults.temperature
          }
        )

        raise 'No completion found' unless response['choices'].any?

        response.dig('choices', 0, 'text').strip
      end

      # Creates a chat completion in OpenAI's API
      #
      # @api private
      #
      # @param prompt [String] The prompt for which to generate a chat completion
      #
      # @return [String] The created chat completion
      #
      def request_chat_completion(prompt)
        response = open_ai_client.chat(
          parameters: {
            model: defaults.model,
            max_tokens: defaults.max_tokens,
            n: defaults.n,
            temperature: defaults.temperature,
            messages: [
              { role: 'system', content: CHAT_SYSTEM_PROMPT },
              { role: 'user', content: prompt }
            ]
          }
        )

        raise 'No chat completion found' unless response['choices'].any?

        response.dig('choices', 0, 'message', 'content').strip
      end

      # Returns the default configuration object for the OpenAI brain
      #
      # @api private
      #
      # @return [Senior::Configuration::OpenAI] The default configuration object for the OpenAI brain.
      #
      def defaults
        Senior.configuration.open_ai
      end
    end
  end
end
