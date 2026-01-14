require 'rails_helper'

RSpec.describe Features::ChangingDegrees do
  describe '.enabled?' do
    after do
      ENV.delete('ENABLE_CHANGING_DEGREES')
    end

    it 'returns true when the ENABLE_CHANGING_DEGREES env var is set' do
      ENV['ENABLE_CHANGING_DEGREES'] = 'true'

      expect(described_class.enabled?).to be true
    end

    it 'returns false when the ENABLE_CHANGING_DEGREES env var is not set' do
      ENV['ENABLE_CHANGING_DEGREES'] = nil

      expect(described_class.enabled?).to be false
    end
  end
end
