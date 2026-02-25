require 'rails_helper'

RSpec.describe Features::Computacion2025 do
  describe '.enabled?' do
    after do
      ENV.delete('ENABLE_COMPUTACION_2025')
    end

    it 'returns true when the ENABLE_COMPUTACION_2025 env var is set' do
      ENV['ENABLE_COMPUTACION_2025'] = 'true'

      expect(described_class.enabled?).to be true
    end

    it 'returns false when the ENABLE_COMPUTACION_2025 env var is not set' do
      ENV['ENABLE_COMPUTACION_2025'] = nil

      expect(described_class.enabled?).to be false
    end
  end
end
