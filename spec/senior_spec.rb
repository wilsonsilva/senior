# frozen_string_literal: true

RSpec.describe Senior do
  describe '.auto_debug' do
    it 'fixes a broken method' do
      result = described_class.auto_debug(BrokenCode.method(:square), 2)

      expect(result).to eq(4)
    end
  end

  describe '.configure' do
    it 'configures the gem' do
      described_class.configure do |config|
        config.open_ai.access_token = 'sk-7wzhjKuFX1oI5NjdUyldT53BlbkFNy7ukdCEn5MOEkN9zzmD'
      end

      expect(described_class.configuration.open_ai.access_token).to eq(
        'sk-7wzhjKuFX1oI5NjdUyldT53BlbkFNy7ukdCEn5MOEkN9zzmD'
      )
    end
  end

  describe '.configuration' do
    it "exposes the gem's configuration" do
      expect(described_class.configuration.open_ai).to be_instance_of(Senior::Configuration::OpenAI)
    end
  end

  describe '.suggest_fix' do
    it 'suggests a fix for a broken method' do
      suggestion = described_class.suggest_fix(BrokenCode.method(:square), 2)

      expect(suggestion).to eq(
        <<~PROMPT.chomp
          def self.square(n)
            n * n
          end
        PROMPT
      )
    end
  end
end
