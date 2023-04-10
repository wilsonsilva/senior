# frozen_string_literal: true

require_relative 'senior/brains/open_ai'
require_relative 'senior/agent'
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
  #  result = Senior.auto_debug(method(:square), 2)
  #  result # => 4
  #
  # @param broken_method [Method] A broken method to be fixed
  # @param args [Object] Arguments given to a broken method
  # @param broken_method_source [String|nil] Source code of the broken method
  #
  # @return [Object] The return value of the previously broken but now fixed method
  #
  def self.auto_debug(broken_method, args, broken_method_source = nil)
    agent.auto_debug(broken_method, args, broken_method_source)
  end

  # Suggests a fix for a broken method
  #
  # @api public
  #
  # @example Suggesting a fix for a broken method
  #  def square(n) = n * y
  #
  #  suggestion = Senior.suggest_fix(method(:square), 2)
  #  suggestion # => "def square(n) = n * n"
  #
  # @param broken_method [Method] A broken method to be fixed
  # @param args [Object] Arguments given to a broken method
  #
  # @return [String] The suggested fix
  #
  def self.suggest_fix(broken_method, args)
    agent.suggest_fix(broken_method, args)
  end

  # Returns an instance of the agent
  #
  # @api private
  #
  # @return [Agent] An instance of the agent
  #
  def self.agent
    @agent ||= Agent.new
  end
end
