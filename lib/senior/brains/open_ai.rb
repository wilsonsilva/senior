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
      # Suggests a fix for a broken method
      #
      # @api private
      #
      # @param erroneous_source [String] Source code of a broken method
      # @param exception_backtrace [String] First line of a broken method's backtrace
      #
      # @return [String] The suggested fix
      #
      def suggest_fix(erroneous_source:, exception_backtrace:)
        prompt = <<~PROMPT
          This is a method's source and the error. Fix the method:

          ## Source:
          #{erroneous_source}

          ## Error:
          #{exception_backtrace}

          ## Updated source:
        PROMPT

        request_completion(prompt)
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
          access_token: ENV.fetch('OPEN_AI_ACCESS_TOKEN'),
          organization_id: ENV.fetch('OPEN_AI_ORGANIZATION_ID')
        )
      end

      # Creates a completion in OpenAI's API
      #
      # @api private
      #
      # @param prompt [String] The prompt for which to generate a completion
      # @param max_tokens [Integer] The maximum number of tokens to generate in the completion. Default value is 1024
      #
      # @return [String] The create completion
      #
      def request_completion(prompt, max_tokens = 1024)
        response = open_ai_client.completions(
          parameters: {
            model: 'text-davinci-003',
            prompt:,
            max_tokens:,
            n: 1,
            stop: nil,
            temperature: 0.7
          }
        )

        raise 'No completion found' unless response['choices'].any?

        response.dig('choices', 0, 'text').strip
      end
    end
  end
end
