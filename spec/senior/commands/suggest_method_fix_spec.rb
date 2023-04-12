# frozen_string_literal: true

RSpec.describe Senior::Commands::SuggestMethodFix do
  let(:suggest_fix) { described_class.new }
  let(:broken_method) { BrokenCode.method(:square) }

  it 'suggests a fix for a broken method' do
    fix = suggest_fix.call(broken_method, 2)

    expect(fix).to eq(
      <<~PROMPT.chomp
        def self.square(n)
          n * n
        end
      PROMPT
    )
  end
end
