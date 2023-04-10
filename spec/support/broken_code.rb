# frozen_string_literal: true

module BrokenCode
  # Raises undefined local variable or method `y' for BrokenCode:Module (NameError)
  def self.square(n) = n * y
end
