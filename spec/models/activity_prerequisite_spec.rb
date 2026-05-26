require 'rails_helper'

RSpec.describe ActivityPrerequisite, type: :model do
  describe 'associations' do
    it { should belong_to(:approvable_needed).class_name('Approvable') }
  end

  describe '#met?' do
    context 'when the approvable needed is approved' do
      it 'returns true' do
        subject_needed = create :subject, :with_exam
        prerequisite = create :activity_prerequisite, approvable_needed: subject_needed.exam

        expect(prerequisite.met?([subject_needed.exam.id])).to be true
      end
    end

    context 'when the approvable needed is not approved' do
      it 'returns false' do
        subject_needed = create :subject, :with_exam
        prerequisite = create :activity_prerequisite, approvable_needed: subject_needed.exam

        expect(prerequisite.met?([])).to be false
      end
    end

    context 'when nested under a NOT and the approvable needed is not approved' do
      it 'is satisfied (regression: exam 1512 / Diseño Lógico)' do
        subject_needed = create :subject
        activity_prerequisite = build :activity_prerequisite, approvable_needed: subject_needed.course
        not_prerequisite = create :not_prerequisite, operands_prerequisites: [activity_prerequisite]

        expect(not_prerequisite.met?([])).to be true
      end
    end
  end
end
