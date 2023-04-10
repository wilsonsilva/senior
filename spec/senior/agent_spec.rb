# frozen_string_literal: true

RSpec.describe Senior::Agent do
  let(:agent) { described_class.new }

  describe '#auto_debug' do
    it 'fixes a broken method' do
      result = agent.auto_debug(BrokenCode.method(:square), 2)

      expect(result).to eq(4)
    end
  end

  describe '#suggest_fix' do
    it 'suggests a fix for a broken method' do
      fix = agent.suggest_fix(BrokenCode.method(:square), 2)

      expect(fix).to eq(
        <<~PROMPT.chomp
          def self.square(n)
            n * n
          end
        PROMPT
      )
    end
  end
end
