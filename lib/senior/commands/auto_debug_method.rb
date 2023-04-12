# frozen_string_literal: true

module Senior
  module Commands
    # Auto debugs a given method using AI to suggest fixes until the method no longer raises exceptions
    #
    # @api private
    #
    class AutoDebugMethod
      # Instantiates a new AutoDebugMethod
      #
      # @api private
      #
      # @param brain [Object] The interface to an AI's API
      #
      def initialize(brain = Brains::OpenAI.new)
        @brain = brain
      end

      # Calls the given method continuously, using AI to attempt to fix it until it no longer raises exceptions
      #
      # @api private
      #
      # @param broken_method [Method] A broken method to be fixed
      # @param args [Object] Arguments given to a broken method
      # @param broken_method_source [String|nil] Source code of the broken method
      #
      # @return [Object] The return value of the previously broken but now fixed method
      #
      def call(broken_method, args, broken_method_source = nil)
        broken_method.call(*args)
      rescue StandardError => e
        puts "The invocation #{broken_method.name}(#{args}) failed. Debugging..."

        suggested_fix_method_source = brain.suggest_method_fix(
          erroneous_source: broken_method_source || broken_method.source,
          exception_backtrace: e.backtrace&.first.to_s
        )

        puts "\nSuggested fix:\n#{suggested_fix_method_source}\n\n"

        suggested_fix_method_name = eval(suggested_fix_method_source)

        call(method(suggested_fix_method_name), args, suggested_fix_method_source)
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
end
