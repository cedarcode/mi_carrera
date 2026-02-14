require 'rails_helper'

RSpec.describe Degree, type: :model do
  describe 'associations' do
    it { should have_many(:degree_plans).dependent(:restrict_with_exception) }
  end

  describe 'validations' do
    subject { create :degree }

    it { is_expected.to validate_presence_of(:current_plan) }
  end

  describe '.default' do
    context 'when computacion exists' do
      it 'returns computacion degree' do
        expect(described_class.default).to eq(degrees(:computacion))
      end
    end

    context 'when computacion does not exist' do
      before do
        DegreePlan.destroy_all
        Degree.destroy_all
      end

      it 'returns nil' do
        expect(described_class.default).to be_nil
      end
    end
  end
end
