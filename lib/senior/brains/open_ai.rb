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
      # @return [String] The create completion
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
