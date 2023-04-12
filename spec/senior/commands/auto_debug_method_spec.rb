# frozen_string_literal: true

RSpec.describe Senior::Commands::AutoDebugMethod do
  let(:auto_debug_method) { described_class.new }
  let(:broken_method) { BrokenCode.method(:square) }

  it 'fixes a broken method' do
    result = auto_debug_method.call(broken_method, 2)

    expect(result).to eq(4)
  end
end
