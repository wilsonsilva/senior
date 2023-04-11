# frozen_string_literal: true

RSpec.describe Senior::Brains::OpenAI do
  let(:open_ai) { described_class.new }

  describe '#suggest_fix' do
    context 'when using a chat model' do
      let(:open_ai_configuration) do
        instance_double(
          Senior::Configuration::OpenAI,
          model: 'gpt-3.5-turbo',
          access_token: ENV.fetch('OPEN_AI_ACCESS_TOKEN'),
          organization_id: ENV.fetch('OPEN_AI_ORGANIZATION_ID'),
          max_tokens: 1024,
          n: 1,
          temperature: 0.7
        )
      end

      before { allow(Senior.configuration).to receive(:open_ai).and_return(open_ai_configuration) }

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

    context 'when using a completion model' do
      let(:open_ai_configuration) do
        instance_double(
          Senior::Configuration::OpenAI,
          model: 'text-davinci-003',
          access_token: ENV.fetch('OPEN_AI_ACCESS_TOKEN'),
          organization_id: ENV.fetch('OPEN_AI_ORGANIZATION_ID'),
          max_tokens: 1024,
          n: 1,
          temperature: 0.7
        )
      end

      before { allow(Senior.configuration).to receive(:open_ai).and_return(open_ai_configuration) }

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

    context 'when using an unknown model' do
      let(:open_ai_configuration) do
        instance_double(
          Senior::Configuration::OpenAI,
          model: 'google-bard-amerda',
          access_token: ENV.fetch('OPEN_AI_ACCESS_TOKEN'),
          organization_id: ENV.fetch('OPEN_AI_ORGANIZATION_ID'),
          max_tokens: 1024,
          n: 1,
          temperature: 0.7
        )
      end

      before { allow(Senior.configuration).to receive(:open_ai).and_return(open_ai_configuration) }

      it 'raises an error' do
        expect do
          open_ai.suggest_fix(
            erroneous_source: 'def self.square(n) = n * y',
            exception_backtrace: "/Users/wilson/projects/rb/senior/spec/support/broken_code.rb:4:in `square'"
          )
        end.to raise_error(
          "Unknown model 'google-bard-amerda'. If this is a mistake, open a PR in github.com/wilsonsilva/senior"
        )
      end
    end
  end
end
