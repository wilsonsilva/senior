# frozen_string_literal: true

module Senior
  # Base class for all Senior's errors
  class Error < StandardError; end

  # Raised when the gem's configuration is faulty
  class ConfigurationError < Error; end
end
