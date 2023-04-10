# frozen_string_literal: true

RSpec.describe Senior::Configuration::OpenAI do
  let(:configuration) { described_class.new }

  describe Senior::Configuration::OpenAI do
    let(:configuration) { described_class.new }

    describe '#access_token' do
      context 'when access token is set' do
        it 'returns the access token' do
          configuration.access_token = 'sk-7wzhjKuFX1oI5NjdUyldT53BlbkFNy7ukdCEn5MOEkN9zzmD'
          expect(configuration.access_token).to eq('sk-7wzhjKuFX1oI5NjdUyldT53BlbkFNy7ukdCEn5MOEkN9zzmD')
        end
      end

      context 'when access token is not set' do
        it 'raises an error' do
          expect { configuration.access_token }.to raise_error(
            Senior::ConfigurationError, /OpenAI access token missing/
          )
        end
      end
    end

    describe '#api_version=' do
      it 'sets the OpenAI API version' do
        configuration.api_version = 'v2'
        expect(configuration.api_version).to eq('v2')
      end
    end

    describe '#initialize' do
      it 'sets default values for OpenAI configuration' do
        aggregate_failures do
          expect(configuration.api_version).to eq('v1')
          expect(configuration.max_tokens).to eq(1024)
          expect(configuration.model).to eq('text-davinci-003')
          expect(configuration.n).to eq(1)
          expect(configuration.organization_id).to be_nil
          expect(configuration.request_timeout).to eq(120)
          expect(configuration.temperature).to eq(0.7)
          expect(configuration.uri_base).to eq('https://api.openai.com/')
        end
      end
    end

    describe '#max_tokens=' do
      it 'sets the OpenAI maximum tokens' do
        configuration.max_tokens = 512
        expect(configuration.max_tokens).to eq(512)
      end
    end

    describe '#model=' do
      it 'sets the OpenAI model' do
        configuration.model = 'text-davinci-002'
        expect(configuration.model).to eq('text-davinci-002')
      end
    end

    describe '#n=' do
      it 'sets the OpenAI N' do
        configuration.n = 2
        expect(configuration.n).to eq(2)
      end
    end

    describe '#organization_id=' do
      it 'sets the OpenAI organization ID' do
        configuration.organization_id = 'org-RiLik18HRjM2wZtZMQ1FsZPp'
        expect(configuration.organization_id).to eq('org-RiLik18HRjM2wZtZMQ1FsZPp')
      end
    end

    describe '#request_timeout=' do
      it 'sets the OpenAI request timeout' do
        configuration.request_timeout = 60
        expect(configuration.request_timeout).to eq(60)
      end
    end

    describe '#temperature=' do
      it 'sets the OpenAI temperature' do
        configuration.temperature = 0.5
        expect(configuration.temperature).to eq(0.5)
      end
    end

    describe '#uri_base=' do
      it 'sets the OpenAI URI base' do
        configuration.uri_base = 'https://openai.example.com/'
        expect(configuration.uri_base).to eq('https://openai.example.com/')
      end
    end
  end
end
