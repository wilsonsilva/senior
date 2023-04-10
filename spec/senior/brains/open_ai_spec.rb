# frozen_string_literal: true

RSpec.describe Senior::Brains::OpenAI do
  let(:open_ai) { described_class.new }

  describe '#suggest_fix' do
    it 'suggests a fix for a broken method' do
      suggested_fix = open_ai.suggest_fix(
        erroneous_source: 'def self.square(n) = n * y',
        exception_backtrace: "/Users/wilson/projects/rb/senior/spec/support/broken_code.rb:4:in `square'"
      )

      expect(suggested_fix).to eq(
        <<~PROMPT.chomp
          def self.square(n)
            n * n
          end
        PROMPT
      )
    end
  end
end
