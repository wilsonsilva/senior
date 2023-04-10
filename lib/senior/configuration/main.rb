# frozen_string_literal: true

require 'senior/configuration/open_ai'

module Senior
  module Configuration
    # Index file for all configurations of the gem
    #
    # @api public
    #
    class Main
      # The OpenAI configuration
      #
      # @api public
      #
      #
      # @example
      #   configuration = Senior::Configuration::Main.new
      #   configuration.open_ai # => #<Configuration::OpenAI:0x00007fa2a61a63d8>
      #
      # @return [Configuration::OpenAI] The OpenAI configuration
      #
      attr_accessor :open_ai

      # Initializes a new instance of the configuration for the Senior gem
      #
      # @api public
      #
      # @example
      #   configuration = Senior::Configuration::Main.new
      #
      def initialize
        @open_ai = Configuration::OpenAI.new
      end
    end
  end
end
