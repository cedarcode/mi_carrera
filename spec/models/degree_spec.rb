require 'rails_helper'

RSpec.describe Degree, type: :model do
  describe 'associations' do
    it { should have_many(:subjects).dependent(:restrict_with_exception) }
    it { should have_many(:subject_groups).dependent(:restrict_with_exception) }
  end

  describe '.default' do
    context 'when computacion exists' do
      let!(:degree) { create(:degree, id: "computacion") }

      it 'returns computacion degree' do
        expect(described_class.default).to eq(degree)
      end
    end
  end
end
