# frozen_string_literal: true

module Senior
  module Commands
    # Suggests a fix for a broken method
    #
    # @api private
    #
    class SuggestMethodFix
      # Instantiates a new SuggestMethodFix
      #
      # @api private
      #
      # @param brain [Object] The interface to an AI's API
      #
      def initialize(brain = Brains::OpenAI.new)
        @brain = brain
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
      def call(broken_method, args)
        broken_method.call(*args)
      rescue StandardError => e
        brain.suggest_method_fix(
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
end
