require 'rails_helper'

RSpec.describe LogicalPrerequisite, type: :model do
  let(:subject1) { create :subject }
  let(:subject2) { create :subject }

  describe '#met?' do
    context 'on logical AND' do
      it 'returns true when all prerequisites met' do
        prerequisite = build(:and_prerequisite, operands_prerequisites: [
          create(:subject_prerequisite, approvable_needed: subject1.course),
          create(:subject_prerequisite, approvable_needed: subject2.course)
        ])

        expect(prerequisite.met?([subject1.course.id])).to be false
        expect(prerequisite.met?([subject1.course.id, subject2.course.id])).to be true
      end
    end

    context 'on logical OR' do
      it 'returns true when any prerequisite met' do
        prerequisite = build(:or_prerequisite, operands_prerequisites: [
          create(:subject_prerequisite, approvable_needed: subject1.course),
          create(:subject_prerequisite, approvable_needed: subject2.course)
        ])

        expect(prerequisite.met?([])).to be false
        expect(prerequisite.met?([subject1.course.id])).to be true
        expect(prerequisite.met?([subject2.course.id])).to be true
      end
    end

    context 'on logical NOT' do
      it 'returns true when prerequisite not met' do
        prerequisite = build(:not_prerequisite, operands_prerequisites: [
          create(:subject_prerequisite, approvable_needed: subject1.course)
        ])

        expect(prerequisite.met?([])).to be true
        expect(prerequisite.met?([subject1.course.id])).to be false
      end
    end

    context 'on logical AT_LEAST' do
      it 'returns true when conditions are met' do
        prerequisite = build(:at_least_prerequisite, amount_of_subjects_needed: 2, operands_prerequisites: [
          create(:subject_prerequisite, approvable_needed: subject1.course),
          create(:subject_prerequisite, approvable_needed: subject2.course),
          create(:subject_prerequisite, approvable_needed: create(:subject).course),
        ])

        expect(prerequisite.met?([subject1.course.id])).to be false
        expect(prerequisite.met?([subject1.course.id, subject2.course.id])).to be true
      end
    end
  end

  describe 'validations' do
    it 'validates that the amount of subjects is less than operand prerequisites count' do
      prerequisite = build(:at_least_prerequisite, amount_of_subjects_needed: 3, operands_prerequisites: [
        create(:subject_prerequisite, approvable_needed: subject1.course),
        create(:subject_prerequisite, approvable_needed: subject2.course),
      ])

      expect(prerequisite).not_to be_valid
    end

    it 'validates that logical_operator is included in the allowed values' do
      should validate_inclusion_of(:logical_operator)
        .in_array(["and", "or", "not", "at_least"])
        .with_message("#{Shoulda::Matchers::ExampleClass} is not a valid logical operator")
    end
  end
end
