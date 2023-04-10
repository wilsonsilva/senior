# frozen_string_literal: true

module Senior
  # Suggests code fixes
  #
  # @api private
  #
  class Agent
    # Instantiates a new Agent
    #
    # @api private
    #
    def initialize(brain = Brains::OpenAI.new)
      @brain = brain
    end

    # Calls the given method continuously, using AI to attempt to fix it until it is no longer raises exceptions
    #
    # @api private
    #
    # @param broken_method [Method] A broken method to be fixed
    # @param args [Object] Arguments given to a broken method
    # @param broken_method_source [String|nil] Source code of the broken method
    #
    # @return [Object] The return value of the previously broken but now fixed method
    #
    def auto_debug(broken_method, args, broken_method_source = nil)
      broken_method.call(*args)
    rescue StandardError => e
      puts "The invocation #{broken_method.name}(#{args}) failed. Debugging..."

      suggested_fix_method_source = brain.suggest_fix(
        erroneous_source: broken_method_source || broken_method.source,
        exception_backtrace: e.backtrace&.first.to_s
      )

      puts "\nSuggested fix:\n#{suggested_fix_method_source}\n\n"

      suggested_fix_method_name = eval(suggested_fix_method_source)

      auto_debug(method(suggested_fix_method_name), args, suggested_fix_method_source)
    end

    # Suggests a fix for a broken method
    #
    # @api private
    #
    # @param broken_method [Method] A broken method to be fixed
    # @param args [Object] Arguments given to a broken method
    #
    # @return [String] The suggested fix
    #
    def suggest_fix(broken_method, args)
      broken_method.call(*args)
    rescue StandardError => e
      brain.suggest_fix(
        erroneous_source: broken_method.source,
        exception_backtrace: e.backtrace&.first.to_s
      )
    end

    private

    # The interface to an AI's API
    #
    # @api private
    #
    # @return [Object]
    #
    attr_reader :brain
  end
end
