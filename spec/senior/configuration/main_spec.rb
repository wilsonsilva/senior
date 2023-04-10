# frozen_string_literal: true

RSpec.describe Senior::Configuration::Main do
  let(:configuration) { described_class.new }

  describe '#initialize' do
    it 'initializes the open_ai attribute with an instance of OpenAI configuration' do
      expect(configuration.open_ai).to be_an_instance_of(Senior::Configuration::OpenAI)
    end
  end

  describe '#open_ai' do
    it 'allows access to OpenAI configuration attributes' do
      configuration.open_ai.access_token = 'sk-7wzhjKuFX1oI5NjdUyldT53BlbkFNy7ukdCEn5MOEkN9zzmD'
      expect(configuration.open_ai.access_token).to eq('sk-7wzhjKuFX1oI5NjdUyldT53BlbkFNy7ukdCEn5MOEkN9zzmD')
    end
  end
end
