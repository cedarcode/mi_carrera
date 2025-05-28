require 'rails_helper'

RSpec.describe SubjectPrerequisite, type: :model do
  describe 'associations' do
    it { should belong_to(:approvable_needed).class_name('Approvable') }
  end

  describe '#met?' do
    context 'when subject course is approved' do
      it 'returns true' do
        subject_needed = create :subject
        prerequisite = create :subject_prerequisite, approvable_needed: subject_needed.course

        expect(prerequisite.met?([subject_needed.course.id])).to be true
      end
    end

    context 'when subject course is not approved' do
      it 'returns false' do
        subject_needed = create :subject
        prerequisite = create :subject_prerequisite, approvable_needed: subject_needed.course

        expect(prerequisite.met?([])).to be false
      end
    end

    context 'when subject exam is approved' do
      it 'returns true' do
        subject_needed = create :subject, :with_exam
        prerequisite = create :subject_prerequisite, approvable_needed: subject_needed.exam

        expect(prerequisite.met?([subject_needed.course.id, subject_needed.exam.id])).to be true
      end
    end

    context 'when subject exam is not approved' do
      it 'returns false' do
        subject_needed = create :subject, :with_exam
        prerequisite = create :subject_prerequisite, approvable_needed: subject_needed.exam

        expect(prerequisite.met?([subject_needed.course.id])).to be false
      end
    end
  end
end
