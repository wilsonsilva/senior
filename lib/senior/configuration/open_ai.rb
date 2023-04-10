# frozen_string_literal: true

module Senior
  module Configuration
    # Encapsulates the OpenAI configuration
    #
    # @api public
    class OpenAI
      # The OpenAI access token
      #
      # @return [String, nil] The OpenAI access token, or nil if not set
      #
      # @example
      #   configuration = Senior::Configuration::OpenAI.new
      #   configuration.access_token = 'your_openai_api_key'
      attr_writer :access_token

      # The OpenAI API version
      #
      # @return [String] The OpenAI API version
      #
      # @example
      #   configuration = Senior::Configuration::OpenAI.new
      #   configuration.api_version = 'v1'
      attr_accessor :api_version

      # The maximum number of tokens to use in the OpenAI API request
      #
      # @return [Integer] The maximum number of tokens to use in the OpenAI API request
      #
      # @example
      #   configuration = Senior::Configuration::OpenAI.new
      #   configuration.max_tokens = 1024
      attr_accessor :max_tokens

      # The OpenAI model to use
      #
      # @return [String] The OpenAI model to use
      #
      # @example
      #   configuration = Senior::Configuration::OpenAI.new
      #   configuration.model = 'text-davinci-003'
      attr_accessor :model

      # The number of responses to generate
      #
      # @return [Integer] The number of responses to generate
      #
      # @example
      #   configuration = Senior::Configuration::OpenAI.new
      #   configuration.n = 1
      attr_accessor :n

      # The OpenAI organization ID
      #
      # @return [String, nil] The OpenAI organization ID, or nil if not set
      #
      # @example
      #   configuration = Senior::Configuration::OpenAI.new
      #   configuration.organization_id = 'your_organization_id'
      attr_accessor :organization_id

      # The maximum amount of time to wait for an OpenAI API request to complete
      #
      # @return [Integer] The maximum amount of time to wait for an OpenAI API request to complete
      #
      # @example
      #   configuration = Senior::Configuration::OpenAI.new
      #   configuration.request_timeout = 120
      attr_accessor :request_timeout

      # The temperature to use in the OpenAI API request
      #
      # @return [Float] The temperature to use in the OpenAI API request
      #
      # @example
      #   configuration = Senior::Configuration::OpenAI.new
      #   configuration.temperature = 0.7
      attr_accessor :temperature

      # The OpenAI URI base
      #
      # @return [String] The OpenAI URI base
      #
      # @example
      #   configuration = Senior::Configuration::OpenAI.new
      #   configuration.uri_base = 'https://api.openai.com/'
      attr_accessor :uri_base

      # The default OpenAI API version
      DEFAULT_API_VERSION = 'v1'

      # The default maximum number of tokens to use in the OpenAI API request
      DEFAULT_MAX_TOKENS = 1024

      # The default OpenAI model to use
      DEFAULT_MODEL = 'text-davinci-003'

      # The default number of responses to generate
      DEFAULT_N = 1

      # The default maximum amount of time to wait for an OpenAI API request to complete
      DEFAULT_REQUEST_TIMEOUT = 120

      # The default temperature to use in the OpenAI API request
      DEFAULT_TEMPERATURE = 0.7

      # The default OpenAI URI base
      DEFAULT_URI_BASE = 'https://api.openai.com/'

      # Initializes a new instance of the OpenAI configuration for the Senior gem
      #
      # @example
      #   configuration = Senior::Configuration::OpenAI.new
      #
      def initialize
        @access_token = nil
        @api_version = DEFAULT_API_VERSION
        @max_tokens = DEFAULT_MAX_TOKENS
        @model = DEFAULT_MODEL
        @n = DEFAULT_N
        @organization_id = nil
        @request_timeout = DEFAULT_REQUEST_TIMEOUT
        @temperature = DEFAULT_TEMPERATURE
        @uri_base = DEFAULT_URI_BASE
      end

      # Gets the OpenAI access token, raising an error if it is not set
      #
      # @raise [ConfigurationError] If the OpenAI access token is not set
      #
      # @return [String] The OpenAI access token.
      #
      # @example
      #   configuration = Senior::Configuration::OpenAI.new
      #   configuration.access_token # => raises ConfigurationError if access token is not set
      #
      def access_token
        return @access_token if @access_token

        error_text = 'OpenAI access token missing! See https://github.com/wilsonsilva/senior#usage'
        raise ConfigurationError, error_text
      end
    end
  end
end
