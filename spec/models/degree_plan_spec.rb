require 'rails_helper'

RSpec.describe DegreePlan, type: :model do
  describe 'associations' do
    it { should belong_to(:degree) }
    it { should have_many(:subjects).dependent(:restrict_with_exception) }
    it { should have_many(:subject_groups).dependent(:restrict_with_exception) }
  end

  describe 'validations' do
    subject { create :degree_plan }

    it { is_expected.to validate_presence_of(:name) }

    it 'validates uniqueness of name scoped to degree' do
      degree_plan = create(:degree_plan)
      duplicate = build(:degree_plan, name: degree_plan.name, degree: degree_plan.degree)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to be_present
    end
  end

  describe '#full_name' do
    it 'returns the degree name and plan name' do
      degree_plan = degree_plans(:computacion_active_plan)

      expect(degree_plan.full_name).to eq("Ingeniería en Computación - Plan 2025")
    end
  end

  describe '.default' do
    context 'when computacion degree exists with active plan' do
      it 'returns the active degree plan for default subject' do
        expect(described_class.default).to eq(Degree.default.active_degree_plan)
      end
    end
  end
end
