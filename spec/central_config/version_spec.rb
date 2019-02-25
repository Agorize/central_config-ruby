# frozen_string_literal: true

RSpec.describe CentralConfig::VERSION do
  it 'returns a string' do
    expect(CentralConfig::VERSION).to match(/\d+\.\d+\.\d+/)
  end
end
