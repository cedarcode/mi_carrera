require 'rails_helper'

RSpec.describe ActivityPrerequisite, type: :model do
  describe '#met?' do
    context 'when approvable needed is an exam' do
      context "when the course of the approvable needed's subject is approved" do
        it 'returns true' do
          subject_needed = create :subject, :with_exam
          prerequisite = create :activity_prerequisite, approvable_needed: subject_needed.exam

          expect(prerequisite.met?([subject_needed.course.id])).to be_truthy
        end
      end

      context "when the the course of the approvable needed's subject is not approved" do
        it 'returns false' do
          subject_needed = create :subject, :with_exam
          prerequisite = create :activity_prerequisite, approvable_needed: subject_needed.exam

          expect(prerequisite.met?([])).to be_falsey
        end
      end
    end

    context 'when approvable needed is a course' do
      it 'returns true' do
        subject_needed = create :subject
        prerequisite = create :activity_prerequisite, approvable_needed: subject_needed.course

        expect(prerequisite.met?([])).to be_truthy
      end
    end
  end
end
