require 'rails_helper'

RSpec.describe EnrollmentPrerequisite, type: :model do
  describe 'associations' do
    it { should belong_to(:approvable_needed).class_name('Approvable') }
  end

  describe '#met?' do
    context 'when the approvable needed is course' do
      it 'returns false' do
        subject_needed = create :subject
        prerequisite = create :enrollment_prerequisite, approvable_needed: subject_needed.course
        expect(prerequisite.met?([])).to be_falsey
        expect(prerequisite.met?([subject_needed.course.id])).to be_falsey
      end
    end

    context 'when the approvable needed is exam' do
      it 'returns false' do
        subject_needed = create :subject, :with_exam
        prerequisite = create :enrollment_prerequisite, approvable_needed: subject_needed.exam
        expect(prerequisite.met?([])).to be_falsey
        expect(prerequisite.met?([subject_needed.exam.id])).to be_falsey
      end
    end
  end
end
