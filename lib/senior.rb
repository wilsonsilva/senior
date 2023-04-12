# frozen_string_literal: true

require_relative 'senior/errors'
require_relative 'senior/commands/auto_debug_method'
require_relative 'senior/commands/suggest_method_fix'
require_relative 'senior/configuration/main'
require_relative 'senior/brains/open_ai'
require_relative 'senior/version'

require 'method_source'

# Encapsulates all the gem's logic
module Senior
  # Calls the given method continuously, using AI to attempt to fix it until it is no longer raises exceptions
  #
  # @api public
  #
  # @example Debugging a broken method
  #  def square(n) = n * y
  #
  #  result = Senior.auto_debug_method(method(:square), 2)
  #  result # => 4
  #
  # @param broken_method [Method] A broken method to be fixed
  # @param args [Object] Arguments given to a broken method
  # @param broken_method_source [String|nil] Source code of the broken method
  #
  # @return [Object] The return value of the previously broken but now fixed method
  #
  def self.auto_debug_method(broken_method, args, broken_method_source = nil)
    Commands::AutoDebugMethod.new(brain).call(broken_method, args, broken_method_source)
  end

  # Suggests a fix for a broken method
  #
  # @api public
  #
  # @example Suggesting a fix for a broken method
  #  def square(n) = n * y
  #
  #  suggestion = Senior.suggest_method_fix(method(:square), 2)
  #  suggestion # => "def square(n) = n * n"
  #
  # @param broken_method [Method] A broken method to be fixed
  # @param args [Object] Arguments given to a broken method
  #
  # @return [String] The suggested fix
  #
  def self.suggest_method_fix(broken_method, args)
    Commands::SuggestMethodFix.new(brain).call(broken_method, args)
  end

  # Returns an interface to OpenAI's API
  #
  # @api private
  #
  # @return [Brain] Interface to OpenAI's API
  #
  def self.brain
    @brain ||= Brains::OpenAI.new
  end

  # Returns the configuration object for the Senior gem
  #
  # @api private
  #
  # @return [Senior::Configuration::Main] The configuration object for the Senior gem
  #
  def self.configuration
    @configuration ||= Configuration::Main.new
  end

  # Provides a way to configure the Senior gem
  #
  # @api public
  #
  # @yield [configuration] A block to configure the Senior gem
  # @yieldparam configuration [Senior::Configuration::Main] The configuration object for the Senior gem
  #
  # @example Configuring the Senior gem
  #   Senior.configure do |config|
  #     config.open_ai.access_token = 'your_openai_api_key'
  #   end
  #
  # @return [void]
  #
  def self.configure
    yield(configuration)
  end
end
